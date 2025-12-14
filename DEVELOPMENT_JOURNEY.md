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
**⏱️ Time Spent For Core:** `~27 Minutes`

what I did in this part: 
 I implemented basic classes:  
 in **data layer** I added `const_values`, `app_exception` and also I implemented `graphql_api_client` as abstract layout and also `graphql_error`as well as `graphql_query_result`. but why? 
 the response is so easy:  Not only our data layer is responsible for working with data, but also it should be expandable against technology. If we directly start to implement graphql, then our application is depend on just a technology could be deprecated in future. 
then I implemented client in `graphql_api_client_impl` and I also implement an extension `query_result_mapper` that convert queryResult to GraphqlQueryResult.
 **domain layer**

in domain I implemented `failure`, `result` and `usecase`. 

 - **failure vs exception**

    Exception is include unnecessary info for ui layer, so we don't need return such huge thing to ui, so failure somehow play entity rule for exception. 
 
  - **Result vs Either**
    I know many of clean implementations using Either, but I prefer result because these four reasons:
    - Either is less readable since you should always remember left was wrong and right is correct.
    - it is additional package by the way
    - using fold helps you to could not skip or ignore error handling
    - less learning curve.

- **General Usecase**

    I have it because we want use command design pattern, and force usecases to use same method (call) entire of app.

**presenter layer**
as you can see here I put providers (shared providers).


#### why I put providers in presenter

If you check many of github codes many of them used these approaches:
- ❌ put providers in class
  - it is wrong because we have to looking inside classes to find which one have provider
- ❌ put provider outside of class in same root
    - in this case, if we want change state management we should change all layouts and it is against of clean architecture while riverpod and provider are related to presentation layer   
- ❌ Put all provider in same place:
   - it make code out of structure
- ✅ I put providers in presentation as it should be

**⏱️ Test Time:** `~15 Minutes`


## 🧱 Implement screen list (step 2)
Of course this steps would be more straight forward since we just need to create a clean folder structure and start to implement, country detail and country list are same feature and based on domain we could not separated these two page together.

I would implement and if I found some critical point then I add and noted it here.

Lets go.


I started with datasource and domain and then I had to change something in core too. 
First of all I Saw implementation of client.query so bad, cause I had to put a lot of if, else condition cause of result nature of query result, second most of time we have data and we should be sure that it is not empty and it is contain specific keys. 
So I created two class first as extension on QueryResult and second as a Mixin since we always need a safeQuery in a project with graphql. 

  *“It can count as over engineering in a small project, but I can say it is prevent to do more than 1 time, so I go trough DRY instead of Wet Principal.”*

  I also implemented providers in presentation.

  then next step would be implement ui part, but so lets go implement ui.


In this step I added screen/views/widgets as you can see I implemented view part in Atomic design pattern principals. The named of list_screen comes from document and I can't change it based on document. I also don't implemented theme yet, I will that in separated step if I had time. 

**⏱️ Test Time:** `~38 Minutes`


I used ai for generating some tests and also review them to be sure all aspects checked. 

**⏱️ Integration Test Time:** `~75 Minutes` 
Configuration and developing test took time cause I could not add test to riverpod and it takes time to learn how I should mock data there.



## 🧱 Implement detail screen (step 4)
when user clicks on an Items we should go to the next page and see detail page, 
In detail page we should see first a part of data and with a expand button we should load other data.

lets go to implement it.

