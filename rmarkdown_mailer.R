library(mailR)
library(rmarkdown)


readRenviron("./.Renviron")


renderRMarkdown <- function(rmarkdown_file, parameters, output_file) {
  # Render a parameterized RMarkdown file.
  #
  # @rmarkdown_file : filepath to the RMarkdown file you want to render.
  # @parameters : list of key-value pairs where key is parameter name
  #   as defined in `rmarkdown_file`.
  #   Ex. list(first_name="Harry", last_name="Potter", list="naughty")
  # @output_file : filepath to where you would like to save the rendered file.
  
  rmarkdown::render(
    rmarkdown_file,
    params = parameters,
    output_file=output_file
  )
}


sendEmailWithAttachments <- function(to, subject, body, attachments) {
  # Send an email with attachments.
  #
  # @to : vector of email adresses.
  #   Ex. c("fake@email.com", "alsofake@email.com")
  # @subject : subject line of email.
  # @body : text body of email.
  # @attachments : vector of filepaths to attachments.
  #   Ex. c("./my-super-cool-report.html")
  #
  # Notes:
  #
  # This function relies on you setting correct values for the O365_USERNAME
  # and O365_PASSWORD environment variables in a local .Renviron file.
  
  send.mail(from = Sys.getenv("O365_USERNAME"),
            to = to,
            subject = subject,
            body = body,
            authenticate = TRUE,
            smtp = list(host.name = "smtp.office365.com",
                        port = 587,
                        user.name = Sys.getenv("O365_USERNAME"),
                        passwd = Sys.getenv("O365_PASSWORD"),
                        tls = TRUE),
            attach.files = attachments,
            send = TRUE
  ) 
}


renderAndEmailRMarkdown <- function(rmarkdown_file, rmarkdown_parameters, output_file, to, subject, body) {
  # Render a parameterized RMarkdown file and email it as an attachment.
  #
  # @rmarkdown_file : filepath to the RMarkdown file you want to render.
  # @rmarkdown_parameters : list of key-value pairs corrosponding to parameters
  #   defined in `rmarkdown_file`.
  #   Ex. list(first_name = "Tim", last_name = "Pettingill")
  # @output_file : filepath to where you want to save the rendered file.
  # @to : vector of email addresses. 
  #   Ex. c("fake@email.com", "alsofake@email.com")
  # @subject : subject line of email.
  # body : Message body of email.
  
  renderRMarkdown(rmarkdown_file, rmarkdown_parameters, output_file)
  sendEmailWithAttachments(to = to, subject = subject, body = body, attachments = c(output_file))
}


distributeRMarkdown <- function(rmarkdown_file, output_file, distribution_file, parameters, to_column, subject, body) {
  # Distribute a parameterized RMarkdown file via email.
  #
  # @rmarkdown_file : filepath to the RMarkdown file you want to distribute.
  # @output_file : filepath where you want to save the rendered file.
  # @distirbution_file : filepath to CSV file that contains data with columns
  #   matching `to_column` and the parameters defined in `parameters_mapping`.
  # @parameters : vector of paramters defined in `rmarkdown_file`.
  #   Each parameter must have a column with the same name in `distribution_file`.
  #   Ex. c("first_name", "last_name")
  # @to_column : Column that contains email addresses in `distribution_file`.
  # @subject: subject line of the email.
  # @body : body of the email.
  
  data <- read.csv(distribution_file, stringsAsFactors = FALSE)
  
  for (row in 1:nrow(data)) {
    rmarkdown_parameters <- as.list(data[row, parameters])
    renderAndEmailRMarkdown(
      rmarkdown_file = rmarkdown_file,
      rmarkdown_parameters = rmarkdown_parameters,
      output_file = output_file,
      to = data[row, to_column],
      subject = subject,
      body = body
    )
  }
}
