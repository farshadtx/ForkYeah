# ForkYeah

### Summary: Include screen shots or a video of your app highlighting its features
<img src="Demo.gif" alt="Demo" style="width:300; height:auto;">

### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
- **Persisting Data**: Used `SwiftData` to persist the list of recipes. I wanted to ensure that we cache the main data models in a future-proof way.
- **Cache Strategy**: Use separate memory and disk cache with 1 hr expiration to enable the app to use less bandwidth for repetitive assets.

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
About 10 hours, since I'm working full-time, I couldn't finish the task in 1-2 days, so it took me about a week to complete all these hours.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
The main tradeoff that I had to make was about not using `@Query` in views. Although this would cost more manual data management and let SwiftUI reactivity we gained explicit control over data flow and better testability.

### Weakest Part of the Project: What do you think is the weakest part of your project?
- **UI/UX**: since I wanted to demo multiple things in a short period of time, I had to combine a lot of features into a small number of views.
- **Test Coverage**: There can be more tests covering the `HomeViewModel` and UI side of the app. I tried to design the app in a way that those tests can be added in the future.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
- I spent about half of the time struggling with a data race in the deletion of data in SwiftData. To be more specific the original relationship that I had between models in `Recipe.swift` which was(`@Relationship(deleteRule: .cascade) var cuisine: Cuisine`) was causing run-time error (data race) and Xcode was not informative about the real reason. I decided to not use the `deleteRule` and manually remove all cuisines after recipes are removed in `Repository`.
- I had a lot of logging at first but removed most of it (like duplicate items at the Repository level) since they were making the console crowded. I only kept major failures and warnings for malformed data.
- I tried to keep both `NetowrkService` and `CacheService` light since there weren't more features to use at this point.
- All view files have a working preview.
- Only the `Core` folder has test coverage.