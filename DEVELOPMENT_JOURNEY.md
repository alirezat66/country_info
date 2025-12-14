# 🛠️ My Personal Development Journey – Country Info

This isn’t just another technical doc. It’s the *story* behind how I built **Country Info**, a Flutter app for Show all countries, and some more details about each country — with a twist: I challenged myself to get it done in around **4 hours**.

Usually such low scale project should be done in 1 to 2 hours but the last time I used Riverpod was 2 years ago also graphql was not so common during these years. I also want to develop test and these document during steps, so I keep it a little bit worse case scenario.

This journey is about fast decisions, clever shortcuts, a few “aha” moments If you’re here for clean code, solid architecture, and a bit of behind-the-scenes chaos — you’re in the right place.

> If you're looking for the clean and polished technical architecture, head over to [README.md](README.md). This one’s a bit more personal.

---

## ⏳ Project Kickoff: Ready, Set, Git!

I kicked things off the usual way: created the Flutter project, connected and pushed it to Git (after creating git ignore file), and poured myself a tea — all within **2 minutes**. ✅

Oh, and I used Flutter version to `3.38.4` and dart `3.10.3`.

---

## 🧱 Infrastructure (Core Layer)

Here’s where the real game begins.

Normally, I’d go with **MVVM** for my own projects (clean, simple, and fast). But in enterprise environments, **Clean Architecture** tends to win. Probably one of the most important thing for a code reviewer is see your skill to work with clean architecture. It’s more familiar across teams and scales better when multiple devs are involved. But I should mentioned here, we should always make decision about architecture based on different factors like : skills of team members, time, scope of project.
Since I did not any of these parameters : 
So for this project, Clean Arch it was — and not the over-engineered kind. Just the most common, Flutter-friendly flavor.

### 🤔 Decision Time: Packages & Principles

- **graphql**:  
  we have different packages that works with graphql, since I did not find any benchmark on them, I decided to go with most used one and last updated one, the **graphql**. 

- **Is that a test? Yes.**  
  I usually love testing. My GitHub is full of examples. But this time? I have 4 hours and it would be enough, I probably will use ai for generate tests, I don't go with TDD approach, I will develop test after each step finished. so for each step I will be an extra step for writing test. for example at the moment the first step is step1-infrastructure, the test step would be step1-infrastructure-test-development. so I would add mockito, patrol, integration_test and flutter_test
  Normally I’d be cautious — some offline issues and network flakiness. But this app’s online-only, and the UI deserves great typography. So in it went.

- **go_router & get_it**:  
  No-brainers. Declarative routing.

- **freezed & equitable*:  
  Every team handles this differently. I separated concerns — used `freezed` in the data layer and `equitable` for domain since we have no logic there. Why? Because **models are models** and **entities are entities**. and both of them are **immutable**, but somewhere that we need compare, and checking unions and etc like states I used **freezed**
- **Riverpod vs generator**:  
  For using riverpod I have two reason, first, generally I am not big fan of using code generators, I had experience in large projects it took a lot time to just generate all classes for small changes. Secondly, I want to review all riverpod one more time during development.
  
  in core layout we would define : network, routing, error handling, consts and views.

  for now, I knew something:
    - we have some consts => `queries` and `values`
    - we have an error handling system, usually I used same approach for most projects, so we have `app_exception` and `Failure`
    - we have an app_router and (we usually have an route observer but since we have no analytics in this project we can skip it)
    - we have a graphql client
    - we have result and usecase
  *“It is important to me that core use same folder structure with other part of app, so we would keep data-domain-presentation folder structure.”*


  So lets go to Start.


**⏱️ Time Spent For adding packages:** `1 Minutes`

