class Item{
	public String name;
	private int weight;

	public int getWeight(){
		return weight;
	}
}

class Weapon extends Item{
	public int damage;
	public int durability;
}

class HealingPotion extends Item{
	private healingPower;

	public int getHealingPower(){
		return healingPower;
	}
}

class Player{
	private String name;
	private PlayerInventory inventory;

	public String getName(){
		return name;
	}

	public void setName(String name){
		this.name = name;
	}
}

class PlayerInventory{
	private Player player;
	public ArrayList<Item> items;

	public getOverallWeight(){
		//...
	}
}