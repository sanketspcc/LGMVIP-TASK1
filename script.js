// Get the input box and the list container elements from the DOM
const inputBox = document.getElementById("input-box");
const listContainer = document.getElementById("list_container");

// Function to add a new task to the list
function addTask() {
    if (inputBox.value === '') {
        alert("You must write something!");
    } else {
        // Create a new list item
        let li = document.createElement("li");
        li.innerHTML = inputBox.value;  // Set the list item text
        listContainer.appendChild(li);  // Add it to the list container

        // Create a span element for the delete button
        let span = document.createElement("span");
        span.innerHTML = "\u00d7";  // "×" symbol for deletion
        li.appendChild(span);  // Add the delete button to the list item
    }
    inputBox.value = "";  // Clear the input box
    saveData();  // Save the list data to localStorage
}

// Event listener for clicking on the list (for toggling completion or deleting tasks)
listContainer.addEventListener("click", function (e) {
    if (e.target.tagName === "LI") {
        e.target.classList.toggle("checked");  // Toggle the "checked" class on click
        saveData();  // Save the updated data
    } else if (e.target.tagName === "SPAN") {
        e.target.parentElement.remove();  // Remove the task on clicking the delete button
        saveData();  // Save the updated data
    }
}, false);

// Function to save the list data to localStorage
function saveData() {
    localStorage.setItem("data", listContainer.innerHTML);  // Save the HTML content of the list
}

// Function to show tasks from localStorage when the page loads
function showTask() {
    listContainer.innerHTML = localStorage.getItem("data");  // Load saved list data from localStorage
}

// Call the showTask function to display any tasks when the page loads
showTask();
