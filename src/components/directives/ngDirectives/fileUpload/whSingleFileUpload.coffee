class whSingleFileUpload extends Directive
  constructor: (FileUploader, authenticationService) ->
    link = (scope, element, attrs, ngModel) =>
      scope.uploadStatus = visible: false
      scope.uploader = new FileUploader url: scope.url, removeAfterUpload: true
      scope.uploader.onSuccessItem = (fileItem, response, status, headers) =>
        scope.$apply ->
          scope.fileUploaded item: response
      scope.uploader.onCompleteAll = () =>
        scope.$apply ->
          scope.resetAttributes()
          if !scope.uploader.getNotUploadedItems().length
            scope.uploadStatus.visible = false

      scope.cancelUpload = () =>
        if scope.uploader.isUploading
          scope.uploader.cancelAll()
        scope.uploader.clearQueue()
        scope.resetAttributes()
        if !scope.uploader.getNotUploadedItems().length
          scope.uploadStatus.visible = false

      scope.doUpload = () =>
        for i in scope.uploader.queue
          i.formData = i.formData || []
          for k,v of scope.attributes || {}
            o = {}
            o[k] = v
            i.formData.push o
          # we have to send this via form data instead of headers, as for IE8/9, we can't control headers when posting a file
          i.formData.Authorization = authenticationService.getAccessToken()
        scope.uploader.uploadAll()

      scope.$watch 'url', =>
        scope.uploader.url = scope.url
        i.url = scope.url for i in scope.uploader.queue

    return {
      link
      restrict: 'A'
      transclude: true
      templateUrl: 'components/directives/ngDirectives/fileUpload/whSingleFileUpload.html'
      scope:
        fileUploaded: '&'
        buttonText: '=?'
        maxFileSizeMB: '=?'
        url: '='
        attributes: '=?'
        resetAttributes: '&'
    }