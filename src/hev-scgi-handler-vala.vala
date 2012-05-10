using HevSCGI;

namespace HevSCGIHandlerModule
{
	class Vala : Object, Handler
	{
		private unowned KeyFile _config = null;
		private string alias = null;
		private string pattern = null;

		public KeyFile config
		{
			get { return _config; }
			set { _config = value; }
		}

		public unowned string get_alias()
		{
			if(null == alias)
			{
				try
				{
					alias = _config.get_string("Module", "Alias");
				}
				catch(Error e)
				{
				}
			}

			return alias;
		}

		public unowned string get_name()
		{
			return "HevSCGIHandlerVala";
		}

		public unowned string get_version()
		{
			return "0.0.1";
		}

		public unowned string get_pattern()
		{
			if(null == pattern)
			{
				try
				{
					pattern = _config.get_string("Module", "Pattern");
				}
				catch(Error e)
				{
				}
			}

			return pattern;
		}

        private async void write_message(OutputStream output_stream)
        {
			Response response = output_stream.get_data("response");
			Task task = response.get_data("task");
			Handler self = task.get_handler();
			Request request = task.get_request();
			HashTable<string, string> hash_table = request.get_header_hash_table();
			string message = null;

			message = "<strong>Handler:</strong> " + self.get_name() + " " + self.get_version();
			message += "<br /><strong>RequestURI:</strong> " + hash_table.lookup("REQUEST_URI");
			message += "<br /><strong>RemoteAddr:</strong> " + hash_table.lookup("REMOTE_ADDR");
			message += "<br /><strong>RemotePort:</strong> " + hash_table.lookup("REMOTE_PORT");

			try
			{
				yield output_stream.write_async(message.data, Priority.DEFAULT);
			}
			catch(Error e)
			{
			}

			output_stream.set_data("response", null);
			response.set_data("task", null);
        }

        private void write_header_handler(void *data)
        {
			Response response = (Response)data;

			OutputStream output_stream = response.get_output_stream();

			output_stream.set_data("response", response);
			write_message.begin(output_stream);
        }

		public void handle (Object scgi_task)
        {
			Task task = (Task)scgi_task;
			Response response = task.get_response();
			HashTable<string, string> hash_table = response.get_header_hash_table();

			hash_table.insert("Status", "200 OK");
			hash_table.insert("Content-Type", "text/html");

			response.set_data("task", task);
			response.write_header(write_header_handler);
        }
	}

	[ModuleInit]
	public Type get_handler_type(TypeModule module)
	{
		return typeof(Vala);
	}
}

