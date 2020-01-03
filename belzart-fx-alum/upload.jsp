<%@ page language="java" contentType="text/html;
charset=UTF-8" pageEncoding="UTF-8"
import=?
"java.io.File,java.util.List,java.util.Iterator,org.apache.commons.file
upload.*"
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"?
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Upload handler</title>
</head>
<body>
<%
// requires:
// http://jakarta.apache.org/commons/fileupload/
if (FileUpload.isMultipartContent(request)) {
DiskFileUpload upload = new DiskFileUpload();
List items = upload.parseRequest(request);
Iterator it = items.iterator();
while(it.hasNext()) {
FileItem item = (FileItem)it.next();
if(!item.isFormField()) {
File fileRef = new File(item.getName());
File savedFile = new File(getServletContext().getRealPath("/"),
fileRef.getName());
item.write(savedFile);
}
}
}
%>
</body>
</html>