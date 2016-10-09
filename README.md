# Snorkel
## MHacks 8: Making Deep Learning Accessible
### Note: made at a hackathon as proof-of-concept and prototype, not to be used in production (security, etc.)

From Devpost:

## Inspiration
The concept of "deep learning" always has (and still is) mystical to even the very best in the field, but this hasn't stopped them from getting the public's attention in a very major way. We're constantly bombarded with headlines that make it clear what kind of impact Deep Learning is having. However, anyone who wants to go further than just being "wowed" by deep learning quickly encounters a roadblock---even the simplest of deep learning applications usually require either copious amounts of code, or extremely obscure difficult code: either way, one quickly gets turned off of deep learning altogether.

This is what prompted Snorkel---while a snorkelling mask allows us regular humans to dive into the deep sea, and Snorkel is meant to do the same for deep learning. Snorkel is an entirely visual interfa## Inspiration
The concept of "deep learning" always has (and still is) mystical to even the very best in the field, but this hasn't stopped them from getting the public's attention in a very major way. We're constantly bombarded with headlines that make it clear what kind of impact Deep Learning is having. However, anyone who wants to go further than just being "wowed" by deep learning quickly encounters a roadblock---even the simplest of deep learning applications usually require either copious amounts of code, or extremely obscure difficult code: either way, one quickly gets turned off of deep learning altogether.

This is what prompted Snorkel---while a snorkelling mask allows us regular humans to dive into the deep sea, and Snorkel is meant to do the same for deep learning. Snorkel is an entirely visual interface to a powerful convolutional neural network engine, allowing users to deploy deep neural networks quickly, and with a much better, more abstract understanding of what's going on, rather than a more syntax-focused micro-view. Let's look at an example:

## What it does [Use Case]

Let's say we're very interested in reading about deep learning, and so we find a couple of introductory articles, and start reading. They all discuss the MNIST dataset, a very common first problem in deep learning. All of the articles are essentially the same with respect to how the neural network works, but it's very hard to decipher that, as they all use different frameworks, different models, etc. However, we've noticed that pretty much every deep learning publication has a graph that looks something like this: ![https://www.dropbox.com/s/vzn185rgq6xih1i/Screen%20Shot%202016-10-09%20at%206.07.29%20AM.png?dl=0]. Thanks to snorkel, all you need is to understand that diagram, and then you can build that directly as your neural network: ![https://www.dropbox.com/s/o45vhsbk7nur8ur/Screen%20Shot%202016-10-09%20at%206.17.52%20AM.png?dl=0]. You can then train the neural network on the dataset of your choice, and try it out yourself!

## How I built it
The backend of Snorkel was built from scratch using Torch7 (a powerful deep learning framework) and LuaJIT (the language it was implemented in).

## Challenges I ran into
A lot of the intricacies of deep learning! There's a reason most languages are so verbose, and generalizing that into an abstract ConvNet model was actually pretty difficult.

## Accomplishments that I'm proud of
Most deep learning projects that are done at hackathons can usually only be taking some pretrained network and feeding in some new data, so it's really exciting that I got to write most of the project from the ground up!

## What I learned
I learned a lot about Torch7 (I had some familiarity, but once again, most of it was plugging stuff into existing models), and about deep learning models in general!

## What's next for Snorkel
I was actually working on free text support instead of just images (and I might have it done by judging time!), and I think that will be a huge step for Snorkel's applicability! Also, it would be cool to have an Algorithmia-style marketplace for models and datasets, and that way people can get started with deep learning even faster!ce to a powerful convolutional neural network engine, allowing users to deploy deep neural networks quickly, and with a much better, more abstract understanding of what's going on, rather than a more syntax-focused micro-view. Let's look at an example:

