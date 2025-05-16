// assets/js/app.js
import "phoenix_html"
import {Socket} from "phoenix"

console.log("チャットアプリを初期化中...")

// WebSocket接続
const socket = new Socket("/socket")
socket.connect()

// チャンネル接続
const channel = socket.channel("room:lobby", {})
channel.join()
  .receive("ok", resp => {
    console.log("チャットルームに接続成功:", resp)
    setupChat()
  })
  .receive("error", resp => {
    console.error("チャットルームへの接続に失敗:", resp)
  })

// チャット機能のセットアップ
function setupChat() {
  const messageInput = document.getElementById("message-input")
  const sendButton = document.getElementById("send-button")
  const messagesContainer = document.getElementById("messages")
  
  if (!messageInput || !sendButton || !messagesContainer) {
    console.error("チャットUI要素が見つかりません")
    return
  }
  
  // メッセージ送信処理
  function sendMessage() {
    const message = messageInput.value.trim()
    if (message) {
      const username = window.userToken || "ゲスト"
      channel.push("new_msg", { body: message, user: username })
      messageInput.value = ""
    }
  }
  
  // 送信ボタンイベント
  sendButton.addEventListener("click", sendMessage)
  
  // Enterキーでの送信
  messageInput.addEventListener("keypress", e => {
    if (e.key === "Enter") {
      sendMessage()
    }
  })
  
  // メッセージ受信時の処理
  channel.on("new_msg", payload => {
    console.log("メッセージ受信:", payload)
    const messageItem = document.createElement("div")
    messageItem.classList.add("mb-2")
    messageItem.innerHTML = `<strong>${payload.user}:</strong> ${payload.body}`
    messagesContainer.appendChild(messageItem)
    messagesContainer.scrollTop = messagesContainer.scrollHeight
  })
  
  console.log("チャット機能の初期化完了")
}
