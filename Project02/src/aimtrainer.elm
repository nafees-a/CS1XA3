import Browser
import Browser.Navigation exposing (Key(..))
import GraphicSVG exposing (..)
import GraphicSVG.App exposing (..)
import Url
import Random exposing (..)

type Msg = Tick Float GetKeyState
         | MakeRequest Browser.UrlRequest
         | UrlChange Url.Url
         | TargetShot
         | MissedShot
         | CreateNextTargetX Float 
         | CreateNextTargetY Float

type alias Model = { targets : Float , size : Float, x : Float , y : Float, accuracy : Float, shots : Float, hit : Float} 

createNextX : Random.Generator Float
createNextX = 
  Random.float -200 200 --Generates an X coordinate

createX : Cmd Msg
createX = Random.generate CreateNextTargetX createNextX

createNextY : Random.Generator Float
createNextY = 
  Random.float -200 180 --Generates a Y coordinate

createY : Cmd Msg
createY = Random.generate CreateNextTargetY createNextY

init : () -> Url.Url -> Key -> ( Model, Cmd Msg )
init flags url key = 
    let 
        model = { targets = 0 , size = 0 , x = 0, y = 0, accuracy = 0, shots =0 , hit =0 }
    in ( model , Cmd.none)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
  case msg of
        Tick time keystate -> if model.size + 0.30 > 15 then ( { model | targets = model.targets + 1, size = 0 }, createX ) -- if the size plus 0.30 is greater than 15, then set size to 0 and add one to target counter
                              else ( { model | size = model.size + 0.30 }, Cmd.none ) -- add 0.30 to the size of the target
            
        MakeRequest req    -> ( model , Cmd.none )
        UrlChange url      -> ( model , Cmd.none )
        TargetShot       -> 
            let 
                newTarget = model.targets + 1 -- add one to target counter
                newHit = model.hit + 1 -- add one to hit counter
                newShots = model.shots + 1 -- add one to shots counter
                newAccuracy = (newHit/newShots)*100 -- calculate accuracy using newHit and newShots, in %
            in
                ( { model |  targets =  newTarget, hit = newHit, shots = newShots, accuracy = newAccuracy, size = 0}, createX ) -- update variables, set size to 0, generate new X coordinate
        MissedShot ->
            let 
                newShots = model.shots + 1 -- add one to shots counter
                newAccuracy = (model.hit/newShots)*100 -- calculate accuracy using newHit and newShots, in %
            in
                ( { model | shots = newShots, accuracy = newAccuracy}, Cmd.none ) -- update variables
        
        CreateNextTargetX num -> ( {model | x = num  } , createY ) -- set new X coordinate, generate Y coordinate
        CreateNextTargetY num -> ( {model | y = num } , Cmd.none ) -- set new Y coordinate

view : Model -> { title : String, body : Collage Msg }
view model = 
     let 
        title = "Aim Trainer"
        body = collage 500 500 shapes


        shapes = [ circleScore ]
        circleScore = group [background, target, accuracyspot, targetsspot, hitspot, shotsspot, aimtrainer]

        background = rect 500 500
                        |> filled white
                        |> notifyTap MissedShot

        target = circle model.size
                      |> filled green
                      |> notifyTap TargetShot
                      |> move (model.x,model.y) 

        accuracyspot = text ("Accuracy: " ++ String.fromFloat model.accuracy)
                      |> bold
                      |> size 15
                      |> filled black
                      |> move (140, 225)
        
        targetsspot = text ("Targets: " ++ String.fromFloat model.targets)
                      |> bold
                      |> size 15
                      |> filled black
                      |> move (-240, 225)

        hitspot = text ("Hits: " ++ String.fromFloat model.hit)
                      |> bold
                      |> size 15
                      |> filled black
                      |> move (140, 210)
        
        shotsspot = text ("Shots: " ++ String.fromFloat model.shots)
                      |> bold
                      |> size 15
                      |> filled black
                      |> move (140, 195)
        
        aimtrainer = text ("AIM TRAINER")
                      |> bold
                      |> size 25
                      |> filled black
                      |> move (-100, 225)

    in { title = title , body = body }

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