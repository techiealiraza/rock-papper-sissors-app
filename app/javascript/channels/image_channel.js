import consumer from "./consumer"

consumer.subscriptions.create("ImageChannel", {
  connected() {
    console.log("connected to Image Channel")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
    // const image = document.getElementById(2)
    // image.src = "/assets/scissor.png";
    // Called when there's incoming data on the websocket for this channel
  }
});
