# github-email

Retrieve a GitHub user's email even if it's not public.
Pulls info from Github user, NPM, activity commits, owned repo commit activity.

![image](https://cloud.githubusercontent.com/assets/39191/7485758/6992dc62-f34f-11e4-9af0-3d0f292f6139.png)


### install
```sh
npm install --global github-email
```

### use
```sh
github-email ghusername
```

# Authenication Token

If the `GH_EMAIL_TOKEN` environment variable is not set, the script will ask
the user to generate a personal access token [for authentication](https://developer.github.com/v3/auth/#basic-authentication). To do this:

1. Visit https://github.com/settings/tokens/new?description=github-email
1. Keep the checkboxes all unchecked
1. Click __Generate Token__.
1. Copy the token.
1. Run this in your shell `export GH_EMAIL_TOKEN=<token>`
1. Also add that line to your shell configuration (e.g. .bashrc)
