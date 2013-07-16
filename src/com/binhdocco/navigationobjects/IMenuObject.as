package com.binhdocco.navigationobjects {
	
	/**
	 * ...
	 * @author binhdocco

	 */
	public interface IMenuObject {
		function deactive(): void;
		function activeFirstItem(): void;
		function activeMenu(index: int, directionY: int): void;
	}
	
}