# Mind the Books

## The Story

I was living in London between 2011 and 2014. During that time, I became a member of a number of libraries in various London boroughs. I borrowed a lot of books, and more often than not, I was forgetting to renew them or return them on time. This cost me quite a lot of money, with accrued fees well in excess of £70. It was then that I got an idea of writing a simple web application that would just sit there and renew your books automatically, so you don't have to remember this.

Due to free time being a sparse resource, I never got around to doing it. Until now.

I'm on a sabbatical these days, and I've applied for a next job as a Ruby programmer. My Ruby skills are rusty and I have never done anything in Rails, so at the interview [they] said, let's see how quickly you can learn Rails. So I said, let me do MTB. They said, go ahead!

So here it is, my repo for all the world to see. Not that anyone would notice, but if someone does, with a bit of luck it can even be usable in a week or two.

 [they]: http://rebased.pl
 
## How to set it up

MTB consists of two parts. The first one is a regular Rails application, and you run it just like any other Rails app. The following command should do the trick:

    bundle install && bundle exec rake db:migrate && rails server

The Web application itself, however, is rather CRUDe and doesn't know anything about interacting with the external Southwark libraries on-line system. That part is done asynchronically by a component called _updater_ (see `lib/fetcher/updater.rb`). You can run updater either from cron, or just in a loop from the command line:

    while true; do ruby lib/fetcher/updater.rb; sleep 5; done

I am using Ruby 2.1.1 (installed using rbenv 0.3.0) on Mint 16 to develop this app. Your mileage may vary.

## Is it online yet?

Not yet but it will be soon.
