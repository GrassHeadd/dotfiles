#!/bin/sh
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Approximate session cost from token counts
cost=$(echo "$input" | jq -r '
  .context_window |
  if .current_usage then
    ((.total_input_tokens // 0) * 0.000003) +
    ((.total_output_tokens // 0) * 0.000015) +
    ((.current_usage.cache_creation_input_tokens // 0) * 0.00000375) +
    ((.current_usage.cache_read_input_tokens // 0) * 0.0000003)
  else empty end
')

# Rate limit usage (Claude.ai subscription plan)
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

cost_str=""
if [ -n "$cost" ]; then
  cost_str=$(printf '  ~$%.2f' "$cost")
fi

rate_str=""
if [ -n "$five_hour" ] || [ -n "$seven_day" ]; then
  rate_str="  plan:"
  if [ -n "$five_hour" ]; then
    rate_str="${rate_str} 5h:$(printf '%.0f' "$five_hour")%"
  fi
  if [ -n "$seven_day" ]; then
    rate_str="${rate_str} 7d:$(printf '%.0f' "$seven_day")%"
  fi
fi

if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  filled=$(( pct / 5 ))
  empty=$(( 20 - filled ))
  bar=""
  i=0
  while [ $i -lt $filled ]; do
    bar="${bar}█"
    i=$(( i + 1 ))
  done
  i=0
  while [ $i -lt $empty ]; do
    bar="${bar}░"
    i=$(( i + 1 ))
  done
  printf '%s  [%s] %d%%%s%s' "$model" "$bar" "$pct" "$cost_str" "$rate_str"
else
  printf '%s%s%s' "$model" "$cost_str" "$rate_str"
fi
