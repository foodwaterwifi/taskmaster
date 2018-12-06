Significant design decisions:

I added a special function in task.ex to handle assignees.
This was because I wanted the user to be able to input a username, and thus I made a validation/constraint function that fetches the id based on the username. It also checks who the one trying to assign the task is. Thus it is able to kill two validation birds (checking the user exists, and checking the person assigning is their manager) in one stone.

I made some decent design decisions with the time logging interface. I don't know if I would call them major.
The most interesting part about it is I use Elixir code to generate a template for the rows of the interface,
and then use Javascript to copy that template and remove the hidden attribute on it. Another decently large
decision I made was to have the edit button replace spans with actual input fields to make editing rows
feel a whole lot nicer.

----
UPDATES IN THE REVISED VERSION
- Users now have a link to their profile and task report in the navbar (lost 1 pt before)
- Fixed bugs with assigning tasks and updating tasks (lost 3 pts before)
- Edit button for tasks no longer exposed to logged-out users
- Better hyperlinking between pages - can now go from task page to assignee page directly
- Slightly modified design of show pages to look less like the default template
- Cute checkbox for task completion display
