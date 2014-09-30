GetAQuoteBookAJob
---
In this little app I've played around with using a foreign API and stubbing the tests with webmock.

Technologies used
---
- rspec
- sinatra
- httparty
- pry
- shotgun
- capybara
- selenium
- selenium-webdriver
- webmock

How to run
---
```sh
cd GetAQuoteBookAJob-Webmockfun
shotgun ./lib/getaquotebookajob.rb -p5000
open localhost:5000/quote
```
