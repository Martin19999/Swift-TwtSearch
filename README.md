Main Page
<img width="317" alt="Screenshot 2023-02-26 at 22 07 27" src="https://user-images.githubusercontent.com/116632169/221441190-fa54cdb2-ebf3-4966-bf97-c6fcebf0950f.png">

Search the tag "art"
<img width="325" alt="Screenshot 2023-02-26 at 22 10 24" src="https://user-images.githubusercontent.com/116632169/221441231-df523800-831a-4192-9b60-f1ec0aee56ee.png">

Click on the first tweet
<img width="325" alt="Screenshot 2023-02-26 at 22 10 14" src="https://user-images.githubusercontent.com/116632169/221441268-e424503f-9af1-4f53-bc02-b66694b9afc2.png">

Check the expanded image
<img width="326" alt="Screenshot 2023-02-26 at 22 10 38" src="https://user-images.githubusercontent.com/116632169/221441289-d289e1e9-d2c7-4706-8a42-122ec1854a9d.png">

Check search history
<img width="326" alt="Screenshot 2023-02-26 at 22 10 52" src="https://user-images.githubusercontent.com/116632169/221441296-be67e1a6-bb24-4da6-ac52-29ee39ae9639.png">





Each of part of the file explained:


Part 1 TweetsTVC 

1. TweetsTVC file is like the “root” of the app, we perform user searches here. These two properties are related to the textlabel, where we enter our search requests.
2. Fetch tweets using function refresh( ) (when press enter, this method is invoked in UITextFieldDelegate, so we can perform user search when hitting enter), and store the fetched result in tweets property. Store searching requests in Userdefault(see no.5 in part 1)
3. Implement data source delegate methods. Such as:
•	numberOfSections
•	numberOfRowsInSection
•	cellForRowAt indexPath

The first two allow us to determine how many sections, how many rows we are going to display in our tweets custom cells. 

The third one allow to select specific data to display according to row number, such as in the cell 0, display the avatar, date, name and text for cell 0, not data for other cells.


4. When we click a certain tweet cell, we want to segue to a different scene (MentionsTVC) that displays the details of that tweet. 
But the next scene doesn’t know what data to present, so we need to pass the data we want to present, from the old scene to the new scene.
There are many ways to do it, but here I chose to create a public property to store the passed data in MentionsTVC. 

It’s a dictionary with a key of types of data: images, urls, hashtags or users. And a value of the displayed content: for key of image, the value is the URL of the image, for others store as String. 

5. The only major part of code in TweetsTVC left unsaid is the part used to store the search results. 
We store the user research history as an array of strings in a computed property. We use a computed one so we can limit the number of stored history more easily. History is added in refresh( ) when user hits enter.


Part 2 MentionsTVC

1. We need to provide our data source for the cells. These methods are similar to those in the TweetsTVC, just using different properties to display different data as needed.
•	numberOfSections
•	numberOfRowsInSection
•	cellForRowAt indexPath

2. Different from TweetsTVC, we also have more than one sections, and each section has different headers. So implement this method as well:
•	titleForHeaderInSection

3. In MentionsTVC, we have 3 different actions when clicking a cell:

•	First, when we click an image, we segue to a new scene called ImageVC.
•	Second, when we click an URL, we open the according webpage.
•	Third, when we click a hashtag or a username, we segue back to TweetsTVC to perform searching.

I determined to use these 2 methods to perform the task:

A.	didSelectRowAt
Here, if it’s an URL, just open it. 
If it’s others, we have two choices of scenes to segue. One forward to a new scene, the other go back to the old scene. However, I can’t simply add two other cases to the switch. Reason below:

Segue.destination in prepare( ) is always TweetsTVC if I put the other two cases in the    switch (I’m sure I use different identifiers! )
And plus, shouldPerformSegue( ) ‘s identifier is always the one goes back to TweetsTVC.

So I had to add another method to deal with the other two scenarios:

B.	shouldPerformSegue
So in all, the logic is: 

If a user clicks on an URL or an Image,  we deal with them in “didSelectRow”. If  a user clicks on a user or hashtag, we deal with them in “shouldPerformSegue”.  So I  can pass data correctly in prepare( ).

All because if I put the other two cases in the switch in “didSelectRow”, shouldPerformSegue( ) always has the same identifier, prepare( ) always has the same destination. 

There is probably something wrong here… but after dealing with cases separately it works fine…

Part 3 Others

I have two files for Tweets Custom Cells and Mentions Custom Cells.

I have an ImageVC and RecentsTVC. I don’t have a file for Recent cells because it’s not a customed one. 

