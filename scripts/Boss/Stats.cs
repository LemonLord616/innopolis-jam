using System;
using Godot;

[GlobalClass]
public partial class Stats : Resource
{
    public struct StatsConfig
    {
        public float health;
        public float maxHealth;
        public float speed;
        public float speedModifier;
    }

    public event Action OnDamageEv;
    public event Action OnHealEv;
    public event Action OnDeadEv;
    public event Action OnSpeedEv;

    [Export] public float CurentHealth {get; private set;}
    [Export] public float MaxHealth { get; private set; }
    [Export] public float Speed { get; private set;}
    [Export] public float SpeedModifier { get; private set;}
    
    public bool IsAlive => CurentHealth > 0f;

    public void Init(StatsConfig config)
    {
        CurentHealth = config.health;
        MaxHealth = config.maxHealth;
        Speed = config.speed;
        SpeedModifier = config.speedModifier;
    }

    public void SetHealt(float addHealt)
    {
        var oldHealth = CurentHealth;
        CurentHealth += addHealt;
        CurentHealth = Math.Clamp(CurentHealth,0f,MaxHealth);

        if (CurentHealth > oldHealth)
        {
            OnHealEv?.Invoke();
        }else if (CurentHealth < oldHealth)
        {
            OnDamageEv?.Invoke();
        }else if (CurentHealth == 0f)
        {
            OnDeadEv?.Invoke();
        }
    }

    public void SetSpeed(float speed)
    {
        Speed += speed;
        OnSpeedEv?.Invoke();
    }
}