using { /Verse.org/Simulation }
using { /UnrealEngine.com/Temporary/Diagnostics }
using { /UnrealEngine.com/Temporary/UI }

game_manager := class(creative_device):

    @editable var PowerUpDevice : power_up_device = power_up_device{}

    var Players : []player = array{}

    OnBeginPlay<override>()<suspends>: void =
        PowerUpDevice.ItemPickedUpEvent.Subscribe(UsePowerUp)

    UsePowerUp(Agent : agent): void =
        if (FortCharacter := Agent.GetFortCharacter[]):
            PowerUpDevice.Pickup()

    InitPlayers(): void =
        set Players = GetPlayspace().GetPlayers()
        if (Player := Players[0]):
            PowerUpDevice.Spawn(Player.GetTransform().Translation)
