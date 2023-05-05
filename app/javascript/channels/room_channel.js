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
      const messageHTML = `<div class = "my-1 flex flex-row">
      <div class = "rounded-full bg-gold_shade2 w-7 text-white text-center h-7">
      ${data.user_name.substring(0,3)}
      </div>
      <div class ="flex flex-col space-y-2 text-xs  ml-2 items-start">
      <div class = "flex flex-row items-end">
        <div class = "text-white">${data.created_at}</div>
      </div>
        <div class="line-clamp-10 max-w-sm text-lg px-3 py-2 my-1 rounded-lg rounded-br-none rounded-tl-none bg-gold text-black">
        ${data.message}
        </div>
      </div>
   </div>`;
   
      msgs.insertAdjacentHTML("afterbegin", messageHTML);
      const last_elem = msgs.firstChild;
      last_elem.scrollIntoView({ behavior: 'smooth', block: 'end' });last_elem.scrollIntoView({ behavior: 'smooth', block: 'end' });
      msg_element.value = "";

    },
  });
})

