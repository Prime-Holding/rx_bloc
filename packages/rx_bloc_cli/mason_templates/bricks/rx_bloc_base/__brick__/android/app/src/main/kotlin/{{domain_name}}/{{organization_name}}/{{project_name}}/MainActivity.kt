package {{domain_name}}.{{organization_name}}.{{project_name}} {{^enable_pin_code}}
import io.flutter.embedding.android.FlutterActivity{{/enable_pin_code}}{{#enable_pin_code}}
import io.flutter.embedding.android.FlutterFragmentActivity{{/enable_pin_code}}
class MainActivity: {{^enable_pin_code}}FlutterActivity(){{/enable_pin_code}}{{#enable_pin_code}}
FlutterFragmentActivity(){{/enable_pin_code}} {
}