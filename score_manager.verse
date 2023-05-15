using { /UnrealEngine.com/Temporary/UI }
using { /Fortnite.com/UI }
using { /Fortnite.com/Devices }
using { /Verse.org/Simulation }

MakeScoreManager<constructor><public>(InPlayer : player, InScoreManagerDevice : score_manager_device) := score_manager:
    MaybePlayer := option{InPlayer}
    MaybePlayerUI := option{GetPlayerUI[InPlayer]}

score_manager := class:
    <# Since we won't recreate the canvas during the score manager lifetime, do it once
    anytime an object of this type is created. #>
    block:
        set Canvas = canvas:
            Slots := array:
                canvas_slot:
                    Widget := stack_box:
                        Orientation := orientation.Vertical
                        Slots := array:
                            stack_box_slot:
                                Widget := TotalGameScoreWidget
                            stack_box_slot:
                                Widget := PendingScoreWidget
                            stack_box_slot:
                                Widget := PickupLevelWidget
                    Offsets := margin{ Top:=0.0, Left:=500.0 }

    AddScoreManagerToUI<public>() : void =
        if (PlayerUI := MaybePlayerUI?):
            PlayerUI.AddWidget(Canvas)
            UpdateUI()

    <# Adds PendingScore to TotalGameScore and resets PendingScore to 0.
    Returns the total number of Pickup Points added. #>
    AddPendingScoreToTotalScore<public>() : int =
        set TotalGameScore += PendingScore

        defer:
            set PendingScore = 0
            UpdateUI()

        PendingScore

    <# Adds the given amount of points to the pending points. #>
    UpdatePendingScore<public>(Points : int) : void =
        set PendingScore += Points
        UpdateUI()
   
    UpdatePickupLevel<public>(Level : int) : void =
        set PickupLevel = Level
        UpdateUI()

    <# Awards the score to the player via the ScoreManagerDevice, activating it. #>
    AwardScore<public>() : void =
        ScoreManagerDevice.SetScoreAward(TotalGameScore)
        if (AwardedPlayer := MaybePlayer?):
            ScoreManagerDevice.Activate(AwardedPlayer)
           
    MaybePlayer<internal> : ?player = false
    MaybePlayerUI<internal> : ?player_ui = false
    ScoreManagerDevice<internal> : score_manager_device = score_manager_device{}
    var Canvas<internal> : canvas = canvas{}
    TotalGameScoreWidget<internal> : text_block = text_block{}
    PendingScoreWidget<internal> : text_block = text_block{}
    PickupLevelWidget<internal> : text_block = text_block{}

    PickupLevelText<private><localizes>(InLevel : int) : message = "Pickup Level: {InLevel}"
    PendingScoreText<private><localizes>(InPoints : int) : message = "Pending Points: {InPoints}"
    TotalGameScoreText<private><localizes>(InPoints : int) : message = "Total Points: {InPoints}"
    var TotalGameScore<private> : int = 0
    var PendingScore<private> : int = 0
    var PickupLevel<private> : int = 0

    UpdateUI<private>() : void =
        if (PlayerUI := MaybePlayerUI?):
            PickupLevelWidget.SetText(PickupLevelText(PickupLevel))
            PendingScoreWidget.SetText(PendingScoreText(PendingScore))
            TotalGameScoreWidget.SetText(TotalGameScoreText(TotalGameScore))
