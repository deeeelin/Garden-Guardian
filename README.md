# Garden Guardian

## Introduction
An AI agent driven plant nursuring APP that supports beginners to experts in gardening tasks


## Our Vision

1. **Mental and Physical Healing** 😁
2. **Beginner Friendly** ✅
3. **Accumulate a Sense of Achievement** 💯

"Take care of plants and help them grow strong while healing and improving yourself."

## Problem backgrounds with similar products(Competitive Product Analysis)

**Issues Identified:**
- Chatbot does not reference the user’s planting data.
- Users need to describe their planting status every time to the Chatbot.
- The Chatbot cannot perform any operations in the app, requiring users to manually act.

**Problems:**
- The Chatbot only offers knowledge-related assistance.
- It is not a primary solution for beginners to quickly manage and learn about planting.

**Solution:**
- After obtaining user consent, the AI assistant can perform operations in the app (e.g., creating records, scheduling watering).
- The AI can manage all planting information, so users do not have to repeat details.



## Features

### Basic Features

We've included several useful tools that help users manage their plants and stay organized:

1. **Achievements and Badges**: As you progress, earn badges for your milestones, whether it's for nurturing multiple plants or contributing to your own health.

2. **Plant Nurturing Record**: Keep a detailed history of each plant's journey, including care logs, growth updates, and key milestones.

3. **Plant Wiki**: Access a rich database of plant species, complete with care guides, common issues, and tips to ensure your plants flourish.

4. **Planting Notes**: Record personal observations and tips for each plant to help you track their progress and adjust care routines.

5. **User’s Own Water Health Record**: Remind you for your health in the same time you are taking care of your plants, Garden-Guardian is also your guradian !

6. **Planting Contribution Stats**: View stats on how actively you contributed to your plants through time.

7. **To-Do List**: Stay on top of your plant care tasks with a built-in to-do list, ensuring nothing is forgotten.

### Meet Blossom: Your Personal AI Plant Care Assistant

* Blossom is the central feature of our app—a smart AI agent designed to automate and simplify your plant care routine. By handling time-consuming tasks, Blossom allows you to focus on enjoying your plants, while the app takes care of the details. Here's how Blossom makes plant care easier:

#### Blossom's Key Features
1. **Add New Plant**: Simply take a photo, and Blossom will identify the plant species and provide personalized care instructions.

2. **Store Nickname**: Customize your plants with nicknames, making it easier to track and organize your plant collection.

3. **Update Care Actions**: Log your care activities—watering, fertilizing, pruning—and Blossom will calculate the next care dates, ensuring your plants are always nurtured on time.

4. **Add Growth Log**: Document your plant's growth progress, with Blossom tracking everything from new leaves to overall size.

5. **Wise Response to User's Questions and Feelings**: Blossom offers positive feedback and encouragement, while adding a personal touch to your plant care routine.

6. **Recall Context**: Blossom remembers past interactions and care actions from you, allowing it to provide smart reminders and tailored advice based on your plant's history.

#### Simplifying Plant Care with AI

* Blossom is more than just a tool—it’s your personal plant care assistant. By automating repetitive tasks and offering smart advice, Blossom helps ensure your plants thrive, while giving you the time to enjoy the beauty of gardening. Combined with our other features, your plant care journey has never been more seamless or enjoyable.


## How to set up

### Prerequisites
* Fluttter installed
* OpenAI api key

### Running the Project
* Clone the project:
  * `$ git clone https://github.com/deeeelin/Garden-Guardian.git` 
* Set your OPENAI_API_KEY environment variable, in terminal type:
  * `$ export OPENAI_API_KEY=<Your OPENAI key>`
* Run flutter commands 
  * `flutter run -d chrome --web-renderer html --dart-define=OPENAI_API_KEY=${OPENAI_API_KEY}`


## Other

* Project Design Gitmind: https://gitmind.com/app/docs/mynrfydi
* Mid project presentation Slides: [https://www.canva.com/design/DAGCfogCbbI/EsDqwey0e0d2wljz1CPQww/
](https://www.canva.com/design/DAGCfogCbbI/fFZyi-KFSJM0cnx7FBl9yg/view?utm_content=DAGCfogCbbI&utm_campaign=designshare&utm_medium=link&utm_source=editor)

### More About Long-term Memory Implementation
- Unlike typical ChatBots with limited context windows, our ChatBot can recall long-term information by querying the database and adding the necessary information back into its context window.
- Implementation:
  - Each message is embedded and stored in the database.
  - If the ChatBot encounters something it doesn't remember, it generates keywords to perform a vector search in the database, retrieves the necessary information, and adds it back to its context window for recall.
  
- Database Memory Implementation:
  - OpenAI embedding: Converts text into vectors representing the meaning of the text.
  - Firebase extension vector search: Embeds the search query and searches the database to find the vector with the nearest distance, which is the most similar message.
  - Retrieves the message and adds it back to the LLM context window.
