# rmarkdown-mailer
Render and distribute parameterized RMarkdown documents via email.

The `distributeRMarkdown` function in [rmarkdown_mailer.R](./rmarkdown_mailer.R)
allows you to render and email RMarkdown files in bulk.

## Requirements

* You must have a current version of the Java JRE installed or else
  the mailR package will not work.
* You must create a .Renviron file in the project root that
  contains your Office365 username and password. You can use
  [.Renviron.example](./.Renviron.example) as a template.
  __DO NOT COMMIT .Renviron FILE TO GIT.__
* You wil need to install the following R packages:
  * mailR
  * rmarkdown

## Usage

1. Clone or download this repository.
2. Open the repository folder in RStudio.
3. Create a .Renviron file and add your O365 credentials.
4. Run the [rmarkdown_mailer.R](./rmarkdown_mailer.R) script to load
   all of the functions into the global environment.
5. In the console window execute the `distributeRMarkdown` function
   with the appropriate arguments. Please read the function docstrings
   to understand what data types the parameters expect.

## Example

Let's walk through an example of distributing the
[sample-rmarkdown-file.Rmd](./sample-rmarkdown-file.Rmd) file found in
the repository.

The RMarkdown file has three parameters:

1. first_name.
2. last_name.
3. list.

First, I will create a CSV file that contains the email
addresses of the people I want to distribute my file to
as well as unique parameter values for each recipient.
Let's say I created a file called "distribution-list.csv"
that looks something like this.

| first_name | last_name | list | email |
| --- | --- | --- | --- |
| Harry | Potter | nice | doyoulikemyscar@hogwarts.com |
| Ron | Weasley | nice | betrayedbyamouse@hogwarts.com |
| Draco | Malfoy | naughty | ihavedaddyissues@hogwarts.com |

The paramter names in the RMarkdown file __must__ must match
the columns in the CSV file or else the script will break.

Next, I'll create a .Renviron file and add the following
variables to it:

* O365_USERNAME.
* O365_PASSWORD.

Now I can run the _rmarkdown_mailer.R_ script to load the
functions into the global environment.

Finally, I'll call the `distributeRMarkdown` function.
Here's what I would provide as function arguments in this example.

```r
distributeRMarkdown(
    rmarkdown_file = "./sample-rmarkdown-file.Rmd",
    output_file = "./christmas-list-notification.html",
    distribution_file = "./distribution-list.csv",
    parameters = c("first_name", "last_name", "list"),
    to_column = "email",
    subject = "Christmas List Notification",
    body = "Please see the attached file regarding your official nice/naughty list assignment."
)
```

That's it! Then I get to sit back and watch as the computer spams
everyone's inbox for me.

## Tips and tricks

If you want to keep the rendered RMarkdown files generated for
each recipient you can pass a  `paste` function to the `output_file`
argument that uses parameter values to create unique filenames.

If your distribution file is in a different format just change the
`read.csv` function to a read function for your specific filetype.
