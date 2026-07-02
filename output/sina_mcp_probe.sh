#!/bin/bash
# Probe Sina Finance MCP over SSE: initialize + tools/list
set -u
BASE="http://mcp.finance.sina.com.cn"
TOKEN="e006299c7538d5d511ea2cbffcbf4eb2"
SSE_OUT=$(mktemp)

# 1. Open SSE stream in background, capture events
curl -sS -N -m 20 -H "X-Auth-Token: $TOKEN" -H "Accept: text/event-stream" "$BASE/sse" > "$SSE_OUT" 2>/dev/null &
SSE_PID=$!

# 2. Wait for the endpoint event to appear
SESSION_PATH=""
for i in $(seq 1 20); do
  SESSION_PATH=$(grep -m1 '^data: /message' "$SSE_OUT" | sed 's/^data: //')
  [ -n "$SESSION_PATH" ] && break
  sleep 0.3
done

if [ -z "$SESSION_PATH" ]; then
  echo "NO_ENDPOINT_EVENT"
  kill $SSE_PID 2>/dev/null
  cat "$SSE_OUT"
  exit 1
fi
echo "ENDPOINT: $SESSION_PATH"
MSG_URL="$BASE$SESSION_PATH"

# 3. Send initialize
curl -sS -m 8 -X POST "$MSG_URL" \
  -H "X-Auth-Token: $TOKEN" -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"probe","version":"1.0"}}}' >/dev/null

sleep 1
# 4. Send initialized notification
curl -sS -m 8 -X POST "$MSG_URL" \
  -H "X-Auth-Token: $TOKEN" -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"notifications/initialized","params":{}}' >/dev/null

# 5. Request tools/list
curl -sS -m 8 -X POST "$MSG_URL" \
  -H "X-Auth-Token: $TOKEN" -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","id":2,"method":"tools/list","params":{}}' >/dev/null

# 6. Wait for responses to arrive on SSE stream
sleep 3
kill $SSE_PID 2>/dev/null

echo "===== SSE STREAM ====="
cat "$SSE_OUT"
rm -f "$SSE_OUT"
