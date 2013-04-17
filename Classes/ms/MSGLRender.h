namespace ms {
	class GLRender : public ms::Object{
	public:
		GLRender();
		virtual ~GLRender();

		virtual void init();
		virtual void setVisible(BOOL _visible){visible = _visible;}
		virtual BOOL getVisible(){return visible;}
		virtual void setPos(const ms::Vector3f& _pos){pos = _pos;}
		virtual ms::Vector3f getPos(){return pos;}
		virtual ms::Vector3f getCurrentScalePoint(){return pos;}
		virtual void draw();
	private:
		BOOL			visible;
		ms::Vector3f	pos;
	};
};
