using HevSCGI;

namespace HevSCGIHandler {

	class Vala : Object, Handler {

		private const string name = "HevSCGIHandlerVala";
		private const string version = "0.0.2";

		private unowned KeyFile _config = null;
		private string alias = null;
		private string pattern = null;

		public KeyFile config {
			get { return _config; }
			set { _config = value; }
		}

		public unowned string get_alias() {
			if(null == alias) {
				try {
					alias = _config.get_string("Module", "Alias");
				} catch(Error e) {
				}
			}

			return alias;
		}

		public unowned string get_name() {
			return name;
		}

		public unowned string get_version() {
			return version;
		}

		public unowned string get_pattern() {
			if(null == pattern) {
				try {
					pattern = _config.get_string("Module", "Pattern");
				} catch(Error e)
				{
				}
			}

			return pattern;
		}

		private async void write_message(Task task, OutputStream output_stream, string message) {
			try {
				yield output_stream.write_async(message.data, Priority.DEFAULT);
			} catch(Error e) {
			}
		}

		public void handle(Object scgi_task) {
			Task task = (Task)scgi_task;
			Request request = (Request)task.get_request();
			Response response = (Response)task.get_response();
			HashTable<string, string> hash_table = response.get_header_hash_table();

			hash_table.insert("Status", "200 OK");
			hash_table.insert("Content-Type", "text/html");

			response.write_header_async.begin(null, (obj, res) => {
				OutputStream output_stream = response.get_output_stream();
				string message = null;

				try {
					response.write_header_async.end(res);
				} catch(Error e) {
				}

				hash_table = request.get_header_hash_table();
				message = "<strong>Handler:</strong> " + get_name() + " " + get_version();
				message += "<br /><strong>RequestURI:</strong> " + hash_table.lookup("REQUEST_URI");
				message += "<br /><strong>RemoteAddr:</strong> " + hash_table.lookup("REMOTE_ADDR");
				message += "<br /><strong>RemotePort:</strong> " + hash_table.lookup("REMOTE_PORT");

				write_message.begin(task, output_stream, message);
			});
        }
	}
}

