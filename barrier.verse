using { /Verse.org/Simulation }
using { /Fortnite.com/Devices }

barrier_timer := class<concrete>(creative_device):
    @editable
    Barrier:barrier_device = barrier_device{}
    @editable
    Trigger:trigger_device = trigger_device{}
    @editable
    BarrierButton:button_device = button_device{}
    @editable
    Timer:timer_device = timer_device{}

    OnBegin<override>()<suspends>:void=
       BarrierButton.InteractedWithEvent.Subscribe(OnButtonInteractedWith) 
       Trigger.TriggeredEvent.Subscribe(OnTriggerTriggered)
       Timer.SuccessEvent.Subscribe(DisableBarrier)

    OnButtonInteractedWith(Player:player):void=
        Barrier.Enable()
        Timer.Begin(Player)

    OnTriggerTriggered(Player:player):void=
        Timer.Begin(Player)

    DisableBarrier(Player:player):void=
        Barrier.Disable()
