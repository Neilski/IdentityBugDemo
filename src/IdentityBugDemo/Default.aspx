<%@ Page Title="Identity Test Harness" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="IdentityBugDemo.Home" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

   <div class="jumbotron">
      <h1>ASP.NET - Identity Test Harness</h1>
      <p>
         This web application, based on the standard Web Forms template,
         demonstrates a potential issue with the ASP.net Identity 2.0
         framework.  It also allows you to explore one possible workaround.
      </p>
   </div>

   <div class="row">
      <div class="col-md-4">
         <h3>Overview</h3>
         <p>
            This web site, built upon the latest ASP.net Identity for Web Forms
            samples, and fully patched, demonstrates the problem with ASP.net
            Identity 2.0 and use of the standard ASp.net Session object.
         </p>
         <p>
            It appears there is a bug with ASP.net Identity 2.0, or more
            correctly, with the underlying Microsoft.Owin.Host.SystemWeb
            library, that potentially precludes the use of ASP.net Identity
            2.0 if your web site needs to use the Session object or, more
            specifically, if your code manipulates the 
            HttpContext.Response.Cookies collection.
         </p>
         <p>
            For more information see:
            <a href="https://katanaproject.codeplex.com/workitem/197">
               CodePlex Issue - Microsoft.Owin.Host.SystemWeb
            </a>
         </p>
      </div>
      <div class="col-md-4">
         <h3>Session Test</h3>
         <p>
            Click the button below to create a single, simple ASP.net Session object.
         </p>
         <p>
            <asp:Button runat="server" ID="btnCreateSession" CssClass="btn btn-default" Text="Create Session" />
            <asp:Button runat="server" ID="btnClearSession" CssClass="btn btn-default" Text="Clear Session" />
         </p>
         <p>
            <asp:Button runat="server" ID="btnCreateCookie" CssClass="btn btn-default" Text="Create Cookie" />
            <asp:Button runat="server" ID="btnClearCookie" CssClass="btn btn-default" Text="Clear Cookie" />
         </p>
         <p>
            Test Session Value:
            <strong>
               <asp:Label runat="server" ID="lblSessionValue"></asp:Label>
            </strong>
         </p>
         <p>
            Test Cookie Value:
            <strong>
               <asp:Label runat="server" ID="lblCookieValue"></asp:Label>
            </strong>
         </p>
         <p>
            User Identity:
            <strong>
               <asp:Label runat="server" ID="lblUserIdentity"></asp:Label>
            </strong>
         </p>
      </div>
      <div class="col-md-4">
         <h3>Steps to Reproduce Problem</h3>
         <ol>
            <li><a runat="server" href="~/Account/Register">Register</a> and create a local account</li>
            <li><a runat="server" href="~/Account/Login">Login</a> to your new account</li>
            <li>Return to this page and create a Session object</li>
            <li>Open a different browser and try and login</li>
         </ol>
         <p>
            Whilst it will appear that your login attempt has been successful,
            your credentials will not have been recognised.
         </p>
         <p>
            <em class="text-warning">
               The real issue here appears to be that if one logged in user
               initialises as Session, then that action will prevent any other 
               user from logging in!
            </em>
         </p>
      </div>
   </div>

   <hr />

   <div class="row">
      <div class="col-md-6">
         <h3>Possible Workaround?</h3>
         <p>
            You will notice that if you create the Session object 
            <em>before</em> login in, the problem appears to be, if not
            fixed, then at least mitigated.
         </p>
         <p>
            This suggests that one possible workaround would be to
            automatically create a Session object for each visitor as part of
            the Session start process.  This could be achieved by adding
            a Session_Start event handler to the applications's Global.asax as
            shown opposite.
         </p>
      </div>
      <div class="col-md-6">
         <h3>Gobal.asax</h3>
         
         <div class="panel">
            <pre>
private void Session_Start(object sender, EventArgs e)
{
   Session["IdentityFixer"] = DateTime.Now;
}
            </pre>
         </div>
      </div>
   </div>
</asp:Content>
