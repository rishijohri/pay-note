# hisabi (Current Name)
So my aim in creating this app was to keep track of user payments and accounts while taking as little information from them as possible.
To summarize i don't want to take any information like bank account details or anything of the sort, and stil be able to produce reliable data, payment history and other information.

# How it works
Ofcourse we would need some form of information about the user. For this app i am currently using SMS for information. Every Bank and Wallet have to send user some form of confirmation about their Transaction other than just an in app notification. The task is to simply retrieve the meaningful data from the SMS and store it. The best part is that this methods works without internet connection.

# Problems
## First
there is lack of data. To train a ML model, we need data. however coming accross this kind of data is not easy. still I plan to incorporate ML model in the application. theres only so much you can do by coding it yourself.
## Second
UI is terrible, at present it does the bare minimum.
# third
I was planning to somehow ask information from other apps on the device. I don't know about its feasability, so its still work in progress.

