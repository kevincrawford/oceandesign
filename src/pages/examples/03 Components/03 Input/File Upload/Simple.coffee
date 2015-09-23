class SimpleFileUpload extends Controller
  resetAttributes: -> @fileAttributes = title: ""
  fileUploaded: (item) -> @uploadedFiles.push { username: "You", uploadedOn: "Now", attachmentName: item.title, attachmentLink: item.url, maxFileSizeMB: "1" }
  constructor: ($scope, FileUploader, Restangular) ->
    @uploadedFiles = [ { username: "Dan", uploadedOn: "1/1/2014", attachmentName: "Something.docx", attachmentLink: "/FakeServices/FileDownload?id=1" }]
    @fileAttributes = title: ""
    @uploadUrl = Restangular.one('account', 123).all('attachment').getRestangularUrl() + "/UploadFile"
