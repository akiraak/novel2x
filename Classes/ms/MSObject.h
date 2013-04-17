namespace ms {
	class Object
	{
	public:
		Object();
		virtual ~Object();
		virtual void init();

		struct NotifyNode : ListNode {
			ms::Object* thisObject;
			void init(ms::Object* _thisObject){
				ListNode::init();
				thisObject = _thisObject;
				
			}
		};
		void addChildNotifyMessage(NotifyNode& node);
		void removeChildNotifyMessage(NotifyNode& node);
		void sendChildNotifyMessage(ms::Uint32 messageCode, void* messageOther);
		virtual void onChildNotifyMessage(ms::Object* sender, ms::Uint32 messageCode, void* messageOther);
	private:
		List		notifyMessageChildList;
	};
};