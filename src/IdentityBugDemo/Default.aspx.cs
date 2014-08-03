using System;
using System.Globalization;
using System.Web;
using System.Web.UI;


namespace IdentityBugDemo
{
   public partial class Home : Page
   {

      private const string SessionKey = "TestSessionValue";
      private const string CookieKey = "TestCookieValue";


      protected void Page_Load(object sender, EventArgs e)
      {
         btnCreateSession.Click += CreateSession;
         btnCreateCookie.Click += CreateCookie;
         btnClearSession.Click += ClearSession;
         btnClearCookie.Click += ClearCookie;
      }


      private void CreateSession(object sender, EventArgs eventArgs)
      {
         Session[SessionKey] =
            DateTime.Now.ToString(CultureInfo.InvariantCulture);
      }


      private void CreateCookie(object sender, EventArgs e)
      {
         var cookie = new HttpCookie(CookieKey)
         {
            Value = DateTime.Now.ToString(CultureInfo.InvariantCulture),
            Expires = DateTime.Now.AddHours(1)
         };
         Response.Cookies.Add(cookie);
      }


      private void ClearSession(object sender, EventArgs eventArgs)
      {
         if (Session[SessionKey] != null)
         {
            Session.Remove(SessionKey);
         }
      }


      private void ClearCookie(object sender, EventArgs eventArgs)
      {
         if (Request.Cookies[CookieKey] != null)
         {
            var cookie = new HttpCookie(CookieKey)
            {
               Expires = DateTime.Now.AddDays(-1)
            };
            Response.Cookies.Add(cookie);
         }
      }


      protected override void OnPreRender(EventArgs e)
      {
         base.OnPreRender(e);

         lblSessionValue.Text = (string) Session[SessionKey] ?? "Not Set";

         var cookie = Request.Cookies[CookieKey];

         if ((cookie != null) && (cookie.Expires >= DateTime.Now))
         {
            lblCookieValue.Text = Server.HtmlEncode(cookie.Value);
         }
         else
         {
            lblCookieValue.Text = "Not Set";
         }

         lblUserIdentity.Text = (User.Identity.IsAuthenticated)
            ? User.Identity.Name
            : "anonymous";
      }

   }
}