# Proxy configuration
# This file contains functions to manage proxy settings

# Default proxy settings
PROXY_HOST="127.0.0.1"
PROXY_PORT="1087"
PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"

# Function to enable proxy
proxy_on() {
  export http_proxy="${PROXY_URL}"
  export https_proxy="${PROXY_URL}"
  export HTTP_PROXY="${PROXY_URL}"
  export HTTPS_PROXY="${PROXY_URL}"
  echo "✅ Proxy enabled: ${PROXY_URL}"
}

# Function to disable proxy
proxy_off() {
  unset http_proxy
  unset https_proxy
  unset HTTP_PROXY
  unset HTTPS_PROXY
  echo "❌ Proxy disabled"
}

# Function to show current proxy status
proxy_status() {
  # 检查环境变量状态
  if [ -n "${http_proxy}" ] || [ -n "${HTTP_PROXY}" ]; then
    echo "✅ Proxy is enabled:"
    echo "   http_proxy=${http_proxy}"
    echo "   https_proxy=${https_proxy}"
  else
    echo "❌ Proxy is disabled (环境变量未设置)"
  fi
  
  # 检查代理服务器是否可用
  if command -v nc &>/dev/null && nc -z -w 1 ${PROXY_HOST} ${PROXY_PORT} &>/dev/null; then
    echo "🟢 Proxy server at ${PROXY_URL} is available (服务器可连接)"
  else
    echo "🔴 Proxy server at ${PROXY_URL} is not available (服务器不可连接)"
  fi
  
  echo ""
  echo "说明: "
  echo "  - 'Proxy is disabled' 表示环境变量未设置，应用程序不会使用代理"
  echo "  - 'Proxy server available' 只表示代理服务器正在运行，与是否启用代理无关"
}

# Function to set custom proxy
proxy_set() {
  if [ "$#" -eq 0 ]; then
    echo "Usage: proxy_set [host] [port]"
    echo "Current settings: host=${PROXY_HOST}, port=${PROXY_PORT}"
    return 1
  fi
  
  if [ "$#" -ge 1 ]; then
    PROXY_HOST="$1"
  fi
  
  if [ "$#" -ge 2 ]; then
    PROXY_PORT="$2"
  fi
  
  PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"
  echo "Proxy settings updated: ${PROXY_URL}"
  
  # If proxy was enabled, update with new settings
  if [ -n "${http_proxy}" ] || [ -n "${HTTP_PROXY}" ]; then
    proxy_on
  fi
}

# Always exclude local addresses from proxy
export no_proxy="localhost,127.0.0.1,::1,*.local"
export NO_PROXY="${no_proxy}"
