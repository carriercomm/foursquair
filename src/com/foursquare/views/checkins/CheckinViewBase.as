////////////////////////////////////////////////////////////
// Project: foursquair 
// Author: Lucas Hrabovsky, Seth Hillinger
// Created: Nov 16, 2009 
////////////////////////////////////////////////////////////

package com.foursquare.views.checkins
{
	
	import com.foursquare.controller.UserDetailsCommand;
	import com.foursquare.events.CheckinEvent;
	import com.foursquare.events.UserEvent;
	import com.foursquare.events.VenueEvent;
	import com.foursquare.models.vo.CheckinVO;
	import com.foursquare.models.vo.UserVO;
	import com.foursquare.views.user.UserDetailsView;
	
	import mx.collections.ArrayCollection;
	import mx.events.CloseEvent;
	import mx.managers.PopUpManager;
	
	import spark.components.SkinnableContainer;
	
	public class CheckinViewBase extends SkinnableContainer
	{
		
		private var _checkins:ArrayCollection;
		private var checkinsChanged:Boolean;
		
		public function CheckinViewBase()
		{
			super();
			addEventListener( UserEvent.GET_DETAILS, getUserDetails, true);
			addEventListener( VenueEvent.GET_VENUE_DETAILS, getVenueDetails, true);
		}
		
		override protected function commitProperties() : void{
			super.commitProperties();
			
			if( checkinsChanged ){
				checkinsChanged = true;
				
				var checkinItem:CheckinItem;
				for (var i:int=0; i<numElements;i++){
					checkinItem = getElementAt(i) as CheckinItem;
					checkinItem.unload();
				}
				removeAllElements();
				
				for each(var checkin:CheckinVO in _checkins){
					checkinItem = new CheckinItem();
					checkinItem.checkinVO = checkin;
					addElement( checkinItem );
				}
			}
		}

		public function getCheckins():void{
			var checkinEvent:CheckinEvent = new CheckinEvent( CheckinEvent.READ );
			dispatchEvent( checkinEvent );
		}
		
		public function openUserDetails(userVO:UserVO):void{
			var userDetails:UserDetailsView = new UserDetailsView();
			userDetails.addEventListener(CloseEvent.CLOSE, onDetailsClose);
			userDetails.user = userVO;
			PopUpManager.addPopUp( userDetails,this);
		}
		
		private function onDetailsClose(event:CloseEvent):void{
			PopUpManager.removePopUp( event.currentTarget as UserDetailsView );
		}
		
		private function getUserDetails(event:UserEvent):void{
			dispatchEvent( event.clone() );
		}
		
		private function getVenueDetails(event:VenueEvent):void{
			dispatchEvent( event.clone() );
		}
		
		[Bindable]
		public function get checkins():ArrayCollection
		{
			return _checkins;
		}

		public function set checkins(value:ArrayCollection):void
		{
			_checkins = value;
			checkinsChanged = true;
			invalidateProperties();
		}

	}
}