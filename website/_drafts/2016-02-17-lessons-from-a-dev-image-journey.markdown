---
layout: post
title:  "Lessons from a Dev Image Journey"
date:   2016-02-17 15:51:30 +0000
categories: jekyll update
---

10 years ago, when I was first learning to program, I compiled a lot of
code. I had discovered so many cool projects that I wanted to run on my
laptop! Following their READMEs, I would download the project source, run
`./configure` to verify that the necessary dependencies were present on my system,
and then run `make` to combine the code and those dependencies.

Inevitably, one of these two steps would complain that I lacked an essential
library. To know how to install it, I would look to the Internet, preferably
for a one-liner command that would solve my problem. Copy-pasting this command
into my terminal usually worked. But when it failed, Google was always right there
to help me fix the problem, ready with another one-liner.

In the end, I got what I wanted: an awesome project running on
my computer, and the feeling that I was a badass debugger. Life was good.

But each new installation, every copy-paste, cluttered up my system a bit more. Eventually,
conflicts between library dependencies began to slow me down. Project READMEs
and Google were no longer up to the task of dealing with my crufty machine. And,
noob that I was, neither was I.

The longer I fought with these types of errors, the more tired I became.
Sometimes, after losing the fight to install a certain project, I would slam my
laptop shut, the failure stinging. I learned a lot during those struggles, but
I lost a lot too. My eagerness was beginning to wear.

The strife continued until one sweltering summer night, shortly after I had acquired
my degree in computer science. After a particularly long installation battle,
I broke. Hot, angry, exausted, I turned my back on
software. It was just too broken for me.

I spent the next year of my life researching and working in the field of
sustainable agriculture. In other words, I had traded my future career in
computer science to go work on a farm.

The despair I experienced that night is real, and still follows me to this day.
My human response is to look for someone to blame. One might say I inflicted
that pain on myself, blindly installing things without understanding what I
was doing or how to deal with the consequences. But a selfish, damadged,
illogical part of me blames it on project authors, who sweep the
details and difficulties of installing dependencies under the rug, offloading
the burden onto those trying to interact with their software.

I understand why they do it. They want to write code for their project, not
concern themselves with the side-issue of installing some dependency! Is it
the author's fault if, more often than not, installation explodes with the
clap of a giant stacktrace? If a user spends hours wrestling the dependency into
submission--an endless loop of googling an error, hacking a line of code here,
chmoding a file there, trying the whole thing again--can the writer be blamed?
How could the writer possibly hope to anticipate the diversity of systems that
might run their software? All software is fundamentally broken, and this
project author should no more pay the price for this iniquity than any
one of us.

But the price does get paid. And as in life, the highest price is most
often paid by those least able to. A software expert pitted against
installing a random package onto a snowflake system will likely emerge
unscathed, equipped as they are with knowing what to
tweak, the error message to google, the IRC channel to ask questions in. A
beginner, on the other hand, stands little chance. Like me, a beginner will likely
give up.

However, it was not my fate to stay on that farm forever. My journey was about
to take a turn, and I would experience something to give hope
to project authors and beginner programmers alike.
The high barrier of entry to many projects can be lowered, and I was about to
find out how.

When I returned to the software scene nearly a year later, things were
changing. OSX package managers were improving, failing less often. More
importantly, though, I
started a new programming job at FreshBooks. I once again found myself facing
the task of setting up my machine for development, this time for their stack.

Given my history with setting up development environments, I expected and
feared the worst. I was therefore astounded when, a couple of hours into my
software position, I had managed to produce a fully functioning FreshBooks humming along
on my laptop. All I had done was download a specific virtual machine image, boot
it, and run `puppet apply --test`. In about the time it took me to drink a cup
of hot tea, my virtual machine was running FreshBooks. It was my first encounter
with development machine automation, and I was smitten.

When I took a step back to deconstruct this magical process, three elements of
the FreshBooks development image strategy stood out to me: virtualization to abstract away
the mess of my underlying system; pre-built images to bootstrap the provisioning
process for the devoper; and configuration management to repeatably and reliably
put the moving pieces of the software stack in place.

Virtualization is the foundation of this strategy.
Virtualization software such as VirtualBox and VMWare uses functionality
provided by the CPU to run a separate operating system with a dedicated kernel and
RAM. Since it relies directly on the host machine's CPU,
virtual machine images can run in isolation from the
snowflake conditions of the host's filesystem. This isolation firmly supports
the rest of the dev-image strategy.

Virtualization is a great start. But for a smooth
developer experience, by itself it's not enough. A virtual machine needs an operating
system and a bunch of configuration before running `puppet agent --test` will
give you a full development stack. This is where the pre-built machine
image, the glue layer of the dev-image strategy, comes in.

The idea is to take a blank image, do everything required to make it developer-ready,
save a snapshot and distribute it.
This snapshot contains just enough software and configuration for a new
developer like me to hit the ground running. The uncertainty around installing
these components is faced only once, at creation time. Instead of needing to
organize a thousand moving pieces, a developer gets a nice little package with
everything already pinned down. And it's not just one developer that
benefits. This work, done once, is reaped by a thousand developers.

And now we come to the crowning glory of this strategy: Configuration management,
or in this case, Puppet. Puppet is a tool that manages machine
configuration and resources by
running description files, called manifests, written in the Puppet language.
The dev image Puppet manifests download git repositories of FreshBooks code,
install system packages needed to compile and run that code, and configure the
various FreshBooks services to talk to each other. Using executable descriptions
for how software should be set up makes sure every developer's machine is
configured in the same way.

Together, these three ideas--virtualization, machine images, and
configuration management--are the basis of the success of the FreshBooks dev
image. They are patterns that appear time and time again in infrastructure
automation. They will appear again before my story is over.

After a few months at FreshBooks, I took over the side project of teaching
software concepts to a group of employees of budding programming skills. We
decided to build a PHP web application together using the Slim framework. Taking
pity on these fledglings, I burdened myself with documenting the OSX
installation process. Boy, did it suck! When I finally ironed out the kinks in
the installation process, I asked someone in the group to try it out. Well, it
didn't work. The difference was the version of OSX they were running. My
instructions, which worked perfectly on my Mountain Lion laptop, were
completely mismatched with this other person's Lion installation. It was a
classic case of "works on my machine".

At this point you might think that I would apply the lessons of the dev image I
used every day, that I would consider its three magic
ingredients--virtualization, pre-built machine images, and configuration
management. But it took a colleague's advice to
set me straight. "Use Vagrant to set everything up," he said, "using Packer to
pre-build images if you need to." Though commonplace now, these terms fell on
fresh ears at the time, and I was about to learn a lot.

During my ensuing research, I dug into Packer. What I discovered was the very
robot used to pre-build the FreshBooks dev images! Packer is a tool that knows how to
create the machine the user wants by looking at JSON description files
written by the user. The JSON files formalize the process for creating images.
None of this `ssh`-ing into a machine, running some commands by hand hopefully without
making any mistakes, and saving a snapshot. With Packer and JSON together, the
user could be certain that any images produced were provisioned exactly how they
had been specified. The user can track changes to the description files, run
automated tests on them, pinpoint when bugs were introduced... basically treat
them as code. I had discovered another principle in infrastructure automation:
Infrastructure As Code.

I began thinking about how I could use pre-built images to help my team. I could
bake everything--Apache, PHP, our web app code and its dependencies--into this image,
and hand that out. But what would happen in the likely event the dependencies
were updated, or the Apache configuration needed changing? The developer would
either have to do the updates manually--a situation I was trying to avoid!--or I
would have to build a new image to be re-downloaded. That sounded like a lot of
work, for both me and the people I was trying to help. It seemed as though
Packer might get me part of what I wanted, giving me an image I could distribute
to my group, but it would not help maintain that image. And so, I began looking at
Vagrant.

At the beginning I had a hard time figuring out what Vagrant did differently than
Packer. "Create and configure lightweight, reproducible, and portable development
environments", touts the Vagrant website. To my untuned ears, this echoed
claims made by Packer about reproducibility around creating and configuring
machines. "Create a single file for your project to describe the type of machine
you want, the software that needs to be installed," it continued. That sounded
like another infrastructure-as-code tool to me! "Store this file with your
project code." No reason not to do that with Packer code. What niche did
Vagrant fill that Packer did not?

It was only by playing with Vagrant that I began to understand how they
differed. Though Vagrant's features overlap with Packer's significantly, Vagrant
is from the ground up centered around developing code. The mere fact
that the `Vagrantfile` (the file that specifies how to provision the virtual
machine) is _designed_ to be stored and tracked with the code being developed is
ground-breaking. Development environments by nature house code that is
constantly changing. As such, the environment itself, and the description of how
to create it, must evolve with the code. Keeping the `Vagrantfile` with the code
allows the developer who is making code changes to also update the development
environment as needed.

The Vagrant CLI further demonstrates how development-centered Vagrant is.
`vagrant provision` enables tight iteration loops, reapplying the `Vagrantfile`
specification without needing to create a machine from scratch.
`vagrant up` further sets Vagrant apart from its image-building
counter-part. Code is meant to be run, to interact with the network, to pick up
changes in the filesystem. The `up` sub-command enables that by applying network and
directory-mounting configurations specified in the `Vagrantfile`.
When developing code, you want to run a debugger on it, to strace it, to view its core dumps.
`vagrant ssh` drops the user into the environment for them to troubleshoot and
experiment. Like Packer's JSON, the `Vagrantfile` specifies which commands create
and provision the machine. But unlike Packer, everything about Vagrant supports
the development of living, breathing, running code.

Together, Vagrant and Packer proved to be just what I needed for that project.
So, at this point you might think that my quest for reproducible development
environments was at an end. To be sure, Vagrant, through its powerful
abstraction, largly frees developers from the constant, ancillary task of
coaxing dependencies into submission. It has truly changed how the industry
develops applications.

But the phrase "works on my machine" had not been
elimitated from the cosmic background of software develompent. Its usage
continued to sour developer-sysadmin relationships. Vagrant may
have been the holy grail of development environments, but it did little to
transition code from a developer's laptop to production. The development and
production environments were still too different.

Why do typical development environments diverge so much from their production
counterparts? What would it look like if we took the tools acquired so far on
this journey, such as virtualization and infrastructure as code, and tried to
build a development environment that was production-like?

I learned part of the answer when I joined a team at FreshBooks whose founding
purpose was to create a staging environment configured by the Puppet code
used in production. As part of my team's work, we maintained a Vagrant setup
that would run the production Puppet manifests for a specific type of host
inside a virtual machine. A developer could create multiple
cooperating types of hosts, one machine per type. But
FreshBooks wasn't just one, or even five hosts. It was probably closer to
twelve. Sad, slow and swappy was the developer's laptop commanded to run even
the smallest part of the production-approximating FreshBooks stack. The lesson I
learned was that virtualization was not lightweight enough to support developing
any non-trivial service-oriented architecture in a production-like manner.

The world around was still evolving. Containers were emerging as a game-changer.
"Docker! Docker! Docker!" was the cry of every devop and cool
person. I found myself working for PagerDuty, on a team attempting to provide a
development machine for the developers there. Wanting to bridge the gap between
development and production, we decided to create a production-in-a-box
development experience. As at FreshBooks, we would use Vagrant and the
production configuration management code (this time, Chef recipes) to create this
environment. But unlike at FreshBooks, we would not try to create one
virtual machine per service. Due to the weight of virtualization, we knew
it wouldn't fit the bill. So we took a different approach, applying a different
pattern: the pattern of containerization.

From a container's perpective, the world superficially looks pretty similar to a
virtual machine. It gets the semblance of an operating system, filesystem and process space all
to itself. But where a virtual machine runs its own kernel and requires
dedicated chunks of RAM, containers share both memory and kernel among
themselves, borrowing these resources from their host machine. This makes them
much more lightweight than virtual machines. Because of this, many more
containers can run on a laptop than can virtual machines. One host or twelve:
with containers, a production-like environment on the laptop seemed ripe for the
taking. I was stoked.

Yet, my team and I were about to learn a hard lesson. We discovered that
production configuration management is a brittle house of cards, relying on
carefully placed secrets, on dependencies downloaded from flakey servers over
leaky Internet pipes, and on the pre-existence of the very infrastructure it is
supposed to create. The development environment we produced, just like the
configuration management it relied on, tended to collapse from the slightest breeze.
It was too sensitive to changes it had no control over.

We succeeded in producing a production-like environment on a laptop, an
achievement in and of itself. This allowed us run continuous integration
testing of our Chef cookbooks, to test certain internal applications that
lacked a staging environment, and to make changes to deployment logic with
confidence. In that respect, it was a success!

But for _application_ development, the overhead was too high. It forced the
application developer to solve problems having nothing to do with their task at hand.
My team learned that while being more correct, imitating production is a lot of
work for everyone, and might not be worth the tradeoff of usability in the case
of application development.

My story takes a small detour here as I learned about a project my friend was
working on. Like me, he absolutely abhorred the idea of installing anything onto
his pristine laptop. He began to create the ultimate kitchen-sink Docker
container. If he wanted to run an ember app, he would install node and bower
into the container. Developing against the latest version of Java? Into the
container it went. Heck, he even ran Docker in his Docker container.
Docker made it so easy to extend containers that his
`Dockerfile`--the simple file used to describe how to create and run a Docker
container--grew to 260 lines, and the image size to 2.5G--a veritable mammoth.
And I was inspired.

I began adding `Dockerfile`s to every repository I touched. If, on my laptop,
`nokogiri` crashed and burned during a project's `bundle install`, that repo
would get a `Dockerfile`. When I found myself needing to run a golang project, rather than
create the crazy directory tree needed for golang development, I hid it all
in a `Dockerfile`. Writing a `Dockerfile` was a small investment that I knew I could
rely on later if I ever needed to rebuild the project, in stark contrast to the
time spent fighting local bundler errors--a tax I paid again and again.

Similar to Vagrantfiles, Dockerfiles use a simple syntax to define how a
container should be created and what service should run in it. Only one service
can run per Docker container, so if you have multiple co-operating service, you
need to run multiple Docker containers that communicate. Docker Compose is a
tool that coordinates this. Its instruction file, `docker-compose.yml`, is
also very simple to write. These files live in the root of a code repository.
It's even possible to build these containers in advance, publishing them to a
central repository. Containerization, infrastructure as code and pre-built
images--check check check! All for the effort of barely lifting a finger.

Back to my team--we had conceded. The cost of producing a smooth production-like
application-development environment might not be worth the reward. But unlike FreshBooks,
PagerDuty didn't yet have a canonical application development
environment and was breaking under the weight of teaching each new developer how
to set up their laptop. They needed an alternative. The simplicity of
setting up Docker for development offered such a different experience from our
production-in-a-box environment, we decided to give it a try.

And this is where we're at, recently having added Docker configuration to two of
our most difficult application repositories to set up. Time will tell how
successful this strategy proves to be! But it's built on good founding principles.

Don't get me wrong, Docker isn't perfect. As an industry we don't yet fully
understand how containers, especially Docker containers, behave under various
pressures. The situation on OSX is even murkier, where Docker containers must
run in a virtual machine, adding another layer of indirection to an already
confusing setup. And the "cutting edge" isn't called that for nothing. Bugs in the
technology have and will continue to bite us.

Despite all this, I have been hard-pressed to find a better bargain:
full, reliable encapsulation of all code and dependencies for the price of
a bit of love and effort. And who knows, maybe one day we will run these same Docker
containers in production, having finally bridged the gap between development
and production, just like the story books say. But for now, I'm just
happy to have helped ease the pain of those I work with.

The other day, I came across this thought:

> "A thriving project is more than a pile of code. It’s the packaging,
explanation, outreach, and empathy of maintainers that make a good project
great."
  -- Joe Nelson, @begriffs, from [this great blog post](http://begriffs.com/posts/2016-01-29-making-twenty-percent-time-work.html)

Perhaps you are a software veteran, and maintain a lot of open source projects.
You have no idea who
is looking at your code, trying to get it to work. Do your projects exclude
people by being hard to install? You no longer have an excuse :) Put a
`Vagrantfile` or a `Dockerfile` or a `docker-compose.yml` in your repo. Even if no one
else uses it, next year, after you upgrade your OS, and can't remember how to
set up your project--these files will still be there, documenting and
automating the process.

Maybe you're new to coding, and spend way too long installing super cool
projects. The next time you find yourself cursing your computer, stop, take a
breath, and remember we've all been there. Remember the lessons from my
journey, so you can avoid some of the pain I went through. There are better ways.
