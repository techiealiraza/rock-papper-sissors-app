import consumer from "./consumer";

document.addEventListener('turbolinks:load', () => {
  const element = document.getElementById('match_id');
  const match_id = element.getAttribute('data-match-id');
  console.log(match_id)
  // debugger
  consumer.subscriptions.create({channel: "RoomChannel", match_id: match_id},  {
    connected() {
      console.log(`Connected .... ${match_id}`);
      // Called when the subscription is ready for use on the server
    },
  
    disconnected() {
      console.log("Disonnected ...!");
      // Called when the subscription has been terminated by the server
    },
  
    received(data) {

      const msgs = document.getElementById("message-list");
      const msg_element = document.getElementById(`msg_field_${data.user_name}`)
      const messageHTML = `<div class ="flex flex-col space-y-2 text-xs  ml-2  items-start"><div class="text-lg px-3 py-2 my-1 rounded-lg rounded-br-none rounded-tl-none bg-gold text-black">${data.user_name}: ${data.message}</div></div>`;
      msgs.insertAdjacentHTML("beforeend", messageHTML);
      const last_elem = msgs.lastChild;
      last_elem.scrollIntoView({ behavior: 'smooth', block: 'end' });last_elem.scrollIntoView({ behavior: 'smooth', block: 'end' });
      msg_element.value = "";

    },
  });
})

