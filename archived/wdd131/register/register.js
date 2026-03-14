// Imports modulate templates
import { participantTemplate } from "./templates.mjs";

// Running count of how many participants are in the form
let participantCount = 0;

// Event listeners and Constants
const addButton = document.getElementById("add");
const form = document.querySelector('form');
addButton.addEventListener("click", addParticipant);
form.addEventListener('submit', handleSubmit);

// Create participants for the page
function addParticipant() {
  participantCount++;
  const newParticipantHTML = participantTemplate(participantCount);

  // Insert new participant before the Add Participant button
  addButton.insertAdjacentHTML("beforebegin", newParticipantHTML)
}

// Create thank you message once form is submitted
function handleSubmit(event) {
  event.preventDefault(); // Prevent default form submission behavior

  // Sum of fees from all participants
  let totalFees = 0;
  for (let i = 1; i <= participantCount; i++) {
    const feeInput = document.getElementById(`fee${i}`);
    const feeValue = parseFloat(feeInput.value) || 0; // Convert to number or default to 0
    totalFees += feeValue;
  }

  // Hide message until form is submitted
  form.style.display = 'none';

  // Get the adult name from the form for message
  const adultName = document.getElementById('adult_name').value;
  const summary = document.getElementById('summary');
  summary.innerHTML = `
    <p>Thank you ${adultName} for registering. You have registered ${participantCount} participants and owe $${totalFees.toFixed(2)} in Fees.</p>
  `;
}

// move automatic run to here now that register.js is modular
document.addEventListener('DOMContentLoaded', () => {
  addParticipant();
});