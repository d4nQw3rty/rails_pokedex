import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
 
  close(){
    e.preventDefault();

    // Remove from parent
    const modal = document.getElementById("modal");
    modal.innerHTML="";
  }
}
