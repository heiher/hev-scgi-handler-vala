/*
 ============================================================================
 Name        : hev-scgi-handler-module.vala
 Author      : Heiher <admin@heiher.info>
 Version     : 0.0.1
 Copyright   : Copyright (C) 2012 everyone.
 Description : 
 ============================================================================
 */

using HevSCGIHandler;

namespace HevSCGIHandlerModule {

	[ModuleInit]
	public Type get_handler_type(TypeModule module) {
		return typeof(HevSCGIHandler.Vala);
	}
}

