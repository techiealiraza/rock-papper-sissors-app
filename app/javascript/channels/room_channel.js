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
      // debugger
      // console.log(data);
      // console.log("data received...!")
      // debugger
      // var txt_field = "msg_field_" + data.user_name;
      // // console.log(txt_field);
      // if (txt_field){
      //   document.getElementById(txt_field).value = ""; // clear field
      // }
      // // Message.create(message: data['message'], user_id: current_user.id, match_id: params[:match_id])
      const msgs = document.getElementById("message-list");
      // Message.create({ message: data['message'], user_id: current_user.id, match_id: params.match_id })
      // const messageHTML = `<li class = "text-white">${data.user_name}: ${data.message} </li>`;
      const messageHTML = `<div class ="flex flex-col space-y-2 text-xs  ml-2  items-start"><div class="px-3 py-2 my-1 rounded-lg rounded-br-none rounded-tl-none bg-gold text-black ">${data.user_name}: ${data.message}</div></div>`;
      msgs.insertAdjacentHTML("beforeend", messageHTML);
    },
  });
})

