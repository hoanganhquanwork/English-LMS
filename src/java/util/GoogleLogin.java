/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import model.OauthAccount;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.fluent.Form;
import org.apache.http.client.fluent.Request;

/**
 *
 * @author Admin
 */
public class GoogleLogin {

    public static String getToken(String code) throws ClientProtocolException, IOException {
        String response = Request.Post(OaccountConstant.GOOGLE_LINK_GET_TOKEN)
                .bodyForm(
                        Form.form()
                                .add("client_id", OaccountConstant.GOOGLE_CLIENT_ID)
                                .add("client_secret", OaccountConstant.GOOGLE_CLIENT_SECRET)
                                .add("redirect_uri", OaccountConstant.GOOGLE_REDIRECT_URI)
                                .add("code", code)
                                .add("grant_type", OaccountConstant.GOOGLE_GRANT_TYPE)
                                .build()
                ).execute().returnContent().asString();
        JsonObject jobj = new Gson().fromJson(response, JsonObject.class);
        return jobj.get("access_token").getAsString();
    }

    public static OauthAccount getUserInfo(final String accessToken) throws ClientProtocolException, IOException {
        String link = OaccountConstant.GOOGLE_LINK_GET_USER_INFO + accessToken;

        String response = Request.Get(link).execute().returnContent().asString();

        OauthAccount googleInfomation = new Gson().fromJson(response, OauthAccount.class);

        return googleInfomation;
    }
}
