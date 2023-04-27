import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById('match_id');
  const match_id = element.getAttribute('data-match-id');
consumer.subscriptions.create({channel: "RandomChannel", match_id: match_id},  {
  connected() {
    console.log(`Connected to Random: ${match_id}`)
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(image_name) {
    const imageContainer = document.getElementById(2);
    imageContainer.src = image_name+'.png';
    console.log(image_name)
    // Called when there's incoming data on the websocket for this channel
  }
});
})
