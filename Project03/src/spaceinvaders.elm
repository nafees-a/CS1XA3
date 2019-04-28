import Browser
import Browser.Navigation exposing (Key(..), load)
import GraphicSVG exposing (..)
import GraphicSVG.App exposing (..)
import Url
import Random exposing (..)
import String exposing (..)
import String
import Html.Attributes exposing (..)
import Html exposing (..)
import Json.Decode as JDecode
import Json.Encode as JEncode
import Http
import Html.Events exposing (..)

mainStyleSheet =
    let
        tag =
            "link"

        attrs =
            [ attribute "Rel" "stylesheet"
            , attribute "property" "stylesheet"
            , attribute "href" "https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
            ]

        children =
            []
    in
        node tag attrs children


type Msg = Tick Float GetKeyState
         | MakeRequest Browser.UrlRequest
         | UrlChange Url.Url
         | StartGame
         | ResetGame
         | CreateNextAlienX Float
         | SignupLoginPage 
         | SignupUser String
         | SignupPass String 
         | GotSignupResponse (Result Http.Error String)
         | GotLoginResponse (Result Http.Error String)
         | GotLogoutResponse (Result Http.Error String)
         | SignupButton
         | LoginButton
         | LogoutButton

rootUrl = "https://mac1xa3.ca/e/nafeesa/"

type alias Model = { shipX : Float , shipY : Float, alienX : Float, alienY : Float, bulletX : Float, bulletY : Float, score : Int, message : String, gameState : State, gameDisplay : Display, username : String, password : String, error : String} 

type Display = Signup
             | Login 
             | Game

type State = Start
           | Playing
           | Dead

createNextX : Random.Generator Float
createNextX = 
  Random.float -200 200 --Generates a new X coordinate for Alien

createX : Cmd Msg
createX = Random.generate CreateNextAlienX createNextX


init : () -> Url.Url -> Key -> ( Model, Cmd Msg )
init flags url key = 
    let 
        model = { shipX = 0 , shipY = -200 , alienX = 0, alienY = 300, bulletX = 0, bulletY = -200, score = 0, message = "A and D to move, Shooting is Automatic. Click anywhere to start." , gameState = Start, gameDisplay = Login, username = "", password = "", error = "" }
    in ( model , Cmd.none )

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = case model.gameState of
                   Start ->
                     case msg of
                       Tick _ _ -> ( model , Cmd.none )
                       MakeRequest _ -> ( model , Cmd.none )
                       UrlChange _ -> ( model , Cmd.none ) 
                       StartGame -> ({ model | gameState = Playing, message = "" }, Cmd.none ) 
                       ResetGame -> ( model , Cmd.none ) 
                       CreateNextAlienX _ -> ( model , Cmd.none )
                       SignupLoginPage -> ({ model | gameDisplay = Signup, username = "", password = "" } , Cmd.none )
                       SignupUser user -> ({ model | username = user } , Cmd.none )
                       SignupPass pass -> ({ model | password = pass } , Cmd.none )
                       GotSignupResponse result ->
                         case result of 
                           Ok "LoggedIn" -> ({ model | error = "Account Created!"}, Cmd.none)
                           Ok _ -> ({ model | error = "Signup Failed."}, Cmd.none)
                           Err error -> (handleError model error, Cmd.none)
                       GotLoginResponse result ->
                         case result of 
                           Ok "LoginFailed" -> ({ model | error = "Failed to Login"}, Cmd.none)
                           Ok _ -> ({ model | gameDisplay = Game}, Cmd.none)
                           Err error -> (handleError model error, Cmd.none)  
                       GotLogoutResponse result ->
                         case result of 
                           Ok info -> ({ model | gameDisplay = Login, username = "", password = "" }, Cmd.none)
                           Err error -> (handleError model error, Cmd.none)     
                       SignupButton -> ( model , signupPost model )
                       LoginButton -> ( model , loginPost model )
                       LogoutButton -> ( model , logoutPost model ) 
                
                   Playing ->
                     case msg of
                       Tick time (keyToState,_,(x,y)) ->
                           -- if the y-value of the alien is less than -200 then you lose
                           if model.alienY < -200 -- Value for lose condition
                             then ({ model | gameState = Dead, message = "Uh oh, you died! Click to Restart"} , Cmd.none )
                           else
                             -- collision detection for if the bullet hits the alien
                             if (model.bulletX + 10 > model.alienX && model.bulletX - 10 < model.alienX && model.bulletY + 10 > model.alienY && model.bulletY - 10 < model.bulletY )
                               then ({ model | score = model.score + 10, alienY = 300, bulletY = -200} , createX)
                           else
                             -- if the bullet goes off the screen, then the y-value is reset to -200
                             if (model.bulletY > 250)
                               then ({ model | bulletX = model.shipX, bulletY = -200} , Cmd.none)
                           else
                            -- if none of the above, then play game, movement and automatic shooting
                            ({model | shipX = if model.shipX >= 200 then model.shipX - 5 else if model.shipX <= -200 then model.shipX + 5 else model.shipX + (4*x), alienY = model.alienY - 4, bulletY = model.bulletY + 20}, Cmd.none)
                       MakeRequest _ -> ( model , Cmd.none )
                       UrlChange _ -> ( model , Cmd.none ) 
                       StartGame -> ({ model | gameState = Playing, message = "" }, Cmd.none ) 
                       ResetGame -> ( model , Cmd.none ) 
                       CreateNextAlienX num -> ({ model | alienX = num } , Cmd.none )
                       SignupLoginPage -> ( model , Cmd.none )
                       SignupUser _ -> ( model , Cmd.none )
                       SignupPass _ -> ( model , Cmd.none )
                       GotSignupResponse _ -> ( model , Cmd.none )
                       GotLoginResponse _ -> ( model , Cmd.none )
                       GotLogoutResponse _ -> ( model , Cmd.none )
                       SignupButton -> ( model , Cmd.none )
                       LoginButton -> ( model , Cmd.none )
                       LogoutButton -> ( model , Cmd.none ) 
                       
                   Dead ->
                     case msg of
                       Tick _ _ -> ( model , Cmd.none )
                       MakeRequest _ -> ( model , Cmd.none )
                       UrlChange _ -> ( model , Cmd.none ) 
                       StartGame -> (model , Cmd.none )
                       -- the variables are reset to the inital values so the person can replay the game if they wish to do so.
                       ResetGame -> ({ model | shipX = 0 , shipY = -200 , alienX = 0, alienY = 250, bulletX = 0, bulletY = -200, score = 0, message = "A and D to move, Shooting is Automatic. Click anywhere to start.", gameState = Start }, Cmd.none ) 
                       CreateNextAlienX _ -> ( model , Cmd.none )
                       SignupLoginPage -> ( model , Cmd.none )
                       SignupUser user -> ( model , Cmd.none )
                       SignupPass pass -> ( model , Cmd.none )
                       GotSignupResponse _ -> ( model , Cmd.none )
                       GotLoginResponse _ -> ( model , Cmd.none )
                       GotLogoutResponse result -> 
                         case result of
                           Ok info -> ({ model | gameDisplay = Signup, username = "", password = "" }, Cmd.none)
                           Err error -> (handleError model error, Cmd.none)
                       SignupButton -> ( model , Cmd.none )
                       LoginButton -> ( model , Cmd.none )
                       LogoutButton -> ( model , logoutPost model ) 
                
view : Model -> { title : String, body : Collage Msg }
view model =
  let
    title = "Space Invaders"
    body = collage 500 500 newDisplay
    newDisplay = case model.gameDisplay of
                  Signup -> signupDisplay
                  Login -> loginDisplay
                  Game -> case model.gameState of
                            Start -> graphics ++ [ logoutGroup |> notifyMouseDown LogoutButton]
                            Playing -> graphics
                            Dead -> graphics ++ [ logoutGroup |> notifyMouseDown LogoutButton]

    graphics = [gamegraphics]
    gamegraphics = group [ background, ship, bullet, alien, scorespot, messagebox ]

    -- black background for the game
    background = rectangle 500 500
                 |> filled black
                 |> notifyMouseDown StartGame
                 |> notifyMouseDown ResetGame

    -- triangle ship, colored purple
    ship = ngon 3 15
           |> filled purple
           |> rotate (degrees 90)
           |> move (model.shipX,model.shipY)
    
    -- bullet is a rectangle, colored white
    bullet = rectangle 3 5
             |> filled white
             |> move (model.bulletX,model.bulletY)
    
    -- alien is a circle, colored green
    alien = circle 10
            |> filled green 
            |> move (model.alienX,model.alienY)
    
    -- score is displayed at the top left of the game screen
    scorespot = GraphicSVG.text ("Score: " ++ String.fromInt model.score)
                |> bold
                |> GraphicSVG.size 10
                |> filled white
                |> move (-240, 225)
    
    -- any other messages before/after game are displayed in the middle
    messagebox = GraphicSVG.text (model.message)
                 |> centered
                 |> GraphicSVG.size 15
                 |> filled white
                 |> move (0,0)
    
    logoutGroup = group [logoutButton, logoutText]

    logoutText = GraphicSVG.text ("Logout")
               |> filled white
               |> move(-240,150)
    
    logoutButton = rectangle 75 15
                 |> filled black
                 |> move (-240, 150)
    
    loginGroup = group [loginButton, loginText]

    loginText = GraphicSVG.text ("Login")
              |> filled white
              |> move(-15,-54)
    
    loginButton = rectangle 75 15
                |> filled black
                |> move(0,-50)

    signupGroup = group[signupButton,signupText]

    signupText = GraphicSVG.text ("Sign up")
               |> filled white
               |> move(-15,-79)
    
    signupButton = rectangle 75 15
                 |> filled black
                 |> move(0,-75)
    
    requestError = GraphicSVG.text (model.error)
                 |> filled white 
                 |> move(-25,100)

    signupDisplay = [loginBackground, signupGroup |> notifyMouseDown SignupButton , requestError]  ++ usernameInput ++ passwordInput
    loginDisplay = [loginBackground, loginGroup |> notifyMouseDown LoginButton , signupGroup |> notifyMouseDown SignupLoginPage , requestError] ++ usernameInput ++  passwordInput

    loginBackground = rectangle 250 250
                    |> filled lightBlue
    usernameInput = [html 250 250 (div [] [mainStyleSheet, input [placeholder "Username", onInput SignupUser, value model.username, Html.Attributes.style "height" "25px", Html.Attributes.style "width" "175px"] []]) |> move(-85, 25)]         
    passwordInput = [html 250 250 (div [] [input [Html.Attributes.type_ "Password", placeholder "Password", onInput SignupPass, value model.password, Html.Attributes.style "height" "25px", Html.Attributes.style "width" "175px"] []]) |> move(-85, 0)]  

  in { title = title , body = body }


-- encodes users information
userEncoder : Model -> JEncode.Value
userEncoder model =
  JEncode.object
    [ ("username", JEncode.string model.username)
    ,
      ("password", JEncode.string model.password)
    ]

-- creating a user and entering to database
signupPost : Model -> Cmd Msg 
signupPost model =
  Http.post 
    { url = rootUrl ++ "usersystem/signupuser/"
    , body = Http.jsonBody <| userEncoder model
    , expect = Http.expectString GotSignupResponse 
    }

-- checks if the user is in the database, and if so, logs them in
loginPost : Model -> Cmd Msg
loginPost model =
  Http.post
    { url = rootUrl ++ "usersystem/loginuser/"
    , body = Http.jsonBody <| userEncoder model
    , expect = Http.expectString GotLoginResponse
    }

-- logs user out
logoutPost : Model -> Cmd Msg 
logoutPost model =
  Http.post
    { url = rootUrl ++ "usersystem/logoutuser"
    , body = Http.jsonBody <| userEncoder model
    , expect = Http.expectString GotLogoutResponse
    }

-- handles errors 
handleError : Model -> Http.Error -> Model
handleError model error =
    case error of
        Http.BadUrl url -> { model | error = "Bad URL: " ++ url }
        Http.Timeout -> { model | error = "Server Timeout" }
        Http.NetworkError -> { model | error = "Network Error" }
        Http.BadStatus i -> { model | error = "Bad Status: " ++ String.fromInt i }
        Http.BadBody body -> { model | error = "Bad Body: " ++ body }

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

main : AppWithTick () Model Msg
main = appWithTick Tick
         { init = init
         , update = update
         , view = view
         , subscriptions = subscriptions
         , onUrlRequest = MakeRequest
         , onUrlChange = UrlChange
         }  