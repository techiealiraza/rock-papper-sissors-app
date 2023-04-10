import consumer from "./consumer"

consumer.subscriptions.create("RoomChannel", {
  connected() {
    console.log("Connected ...!")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log("Disonnected ...!")
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    Message.create({ message: data['message'], user_id: current_user.id, match_id: params.match_id })
  }
});
