import consumer from "./consumer"

consumer.subscriptions.create("TimerChannel", {
  connected() {
    console.log("Connected to Timer Channel")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log("Disconnected from Timer Channel")
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(`>>>>>>>>>:: ${data}`);
    debugger

    var seconds = data
    const displayDiv = document.getElementById("second_timer");
  
    const intervalId = setInterval(() => {
      debugger
      displayDiv.textContent = seconds;
      seconds--;
      console.log(seconds);
  
      if (seconds < 0) {
        clearInterval(intervalId);
      }
    }, 1000);
  }
});
