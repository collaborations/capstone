# Step Stone

### Helping Seattle's homeless find what they need, when they need it most

[Check out our site!](http://step-stone.me)

## Setup

1. Install Postgres
    * For debian based linux distros this should be:
        `sudo apt-get install postgresql`
2. Install RVM
    ```
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
    \curl -sSL https://get.rvm.io | bash -s stable --rails
    ```
3. Install bundler
    `gem install bundler`
4. Clone this repo and run bundler
    ```
    git clone git@github.com:collaborations/capstone.git
    cd capstone
    bundle
    ```
    * If it errors when installing pg, you may need to install libpq-dev:
    `sudo apt-get install libpq-dev`
5. Create and seed databases
    ```
    rake db:create
    rake db:seed
    ```


