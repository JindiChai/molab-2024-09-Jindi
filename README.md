# molab-2024-09-Jindi

# Week 1

Since I have no experience with app development and have never worked with Swift, I chose to watch the "100 Days of SwiftUI" video series, covering days 1 to 7. It took me a few hours to learn and understand the basic operations of Swift, but it has been very helpful in getting started with Swift programming.

For this week's assignment, I referred to the sample playground for further ideas on how to work with emojis. I chose to create a simple drawing of a house using emojis. A small house will appear on the playground's bottom screen when the ▶️ button is pressed. Since this project is a simple first try at Swift programming, I didn't encounter any difficulties that I couldn’t solve. This has been a good start for me!

# Week 2 

This week, I spent a significant amount of time trying to understand days 8-14 of the "100 Days of SwiftUI" video series. The content and code I learned this week were noticeably more complex and challenging compared to last week. Even after watching the instructional videos, I'm still not entirely confident that I fully grasp all the concepts covered. However, as I continue to use Swift more frequently, I think I will be able to better understand these concepts.

I attempted to create my own ASCII image based on the examples and code provided in the "02-Ascii-Play" section. I copied some food ASCII art from the ASCII art website and made a picnic scene. While writing the code, I encountered some difficulties because the number of lines in each piece of ASCII art was different, which caused some of the bigger ASCII art to lose some lines when displayed. To solve this problem, I tried modifying the code by checking the number of lines in each part and adding blank lines to the parts with fewer lines. This approach worked, and I was able to solve the issue. For better visual appeal, I also experimented with aligning some ASCII art from the bottom, which made the overall image look more balanced and visually interesting.

# Week 3

This week, I continued studying the "100 Days of SwiftUI" video series, focusing on the Starting SwiftUI section. Following along with the small projects in the videos has been very helpful for my understanding and practice of SwiftUI. If I have enough time, I plan to watch more content later in the "100 Days" series.

For this week's assignment, I tried to create a simple SwiftUI page called "Get Today's Lucky Foods and Colors." This interface can randomly generate a background color and a fruit, and when you click the "GET!" button, it will randomly generate a new color and fruit.

# Week 4
This week, I attempted to combine two techniques—sound playback and time management—to create a timer that tracks focus time. The inspiration came from my habit of losing focus when doing homework or other tasks, often getting distracted by checking my phone, which interrupts my workflow. This timer visualizes time, helping me stay focused on the tasks I should be doing. During the countdown, the timer also plays background music suitable for concentration, allowing people to work in a more comfortable state. I also set up several different time options so that users can choose the focus duration that suits them best.

One problem I encountered during programming was that when I used the default back button, the timer would automatically stop, but the music would continue playing. If I started the timer again in this situation, multiple background tracks would overlap. To fix this issue, I looked up some resources and decided to hide the default back button and add a new custom back button. I bound a function to this button that stops the music and returns to the previous page when clicked, which finally solved the problem.

# Week 5
This week, I continued improving my app based on the project from last week. I applied the @AppStorage functionality that I learned this week to replace the previously used @State. Now, after users use the focus timer, the system will automatically save the last selected duration, making it more convenient for users to repeat their focus sessions. Additionally, I used @AppStorage to add a counter feature, which tracks how many times the user has focused.

Beyond that, I also improved the UI of the focus timer. I added a background color to the main interface and implemented a visual remaining time bar when the focus session starts. This allows users to clearly see how much time has passed during their session.

# Week 6
This week, I tried to apply the technique I learned in class, using Swift to store and update data with JSON, and I modified my timer app from last week. I replaced the previous @AppStorage storage (for focus session count and time options) with JSON-based storage. Additionally, I added an option to change the timer’s background image and stored this data using JSON as well. In the coding process, I first tried to read and understand the sample code's logic. Then, I spent a lot of time modifying my original code, as it wasn't fully compatible with JSON fetching methods (this part was much more difficult and complex than I initially expected). Although I originally planned to add a feature allowing users to upload their own images, due to time and technical limitations, I couldn't complete this. If time permits, I might continue trying this part.

# Week 7
This week, I continued with my plan from last week by adding an option to my focus timer app that allows users to upload a custom background from their photo library. I used the Instafilter sample we worked on in class as a reference to modify my original code and implement the functionality to access the user's photo library. Once a picture is selected, it is uploaded and saved in the same folder as the JSON data. After making this modification, I encountered some UI compatibility issues, such as the time display and remaining time progress bar being partially obscured due to different background image proportions. After researching SwiftUI documentation, I ultimately solved the problem by using `UIScreen` to store the device dimensions and apply them to the width and height of the progress bar.
