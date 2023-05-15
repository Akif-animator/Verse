using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }

game_manager := class(creative_device):

    @editable var PowerUpDevice : power_up_device = power_up_device{}

    var Players : []player = array{}

    OnBeginPlay<override>()<suspends>: void =
        PowerUpDevice.ItemPickedUpEvent.Subscribe(UsePowerUp)
