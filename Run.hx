import haxe.io.Path;
import sys.FileSystem;

function log(s)
{
   Sys.println(s);
}

function isNonInteractive()
{
   final varName = "HXCPP_NONINTERACTIVE";

   return switch Sys.getEnv(varName)
   {
      case null:
         Lambda.exists(Sys.args(), arg -> arg.indexOf('-D$varName') == 0);
      case _:
         true;
   }
}

function run(_dir, _command)
{
   final oldDir = Sys.getCwd();
   
   Sys.setCwd(_dir);
   Sys.command(_command);
   Sys.setCwd(oldDir);
}

function setup(_absOutDir)
{
   log("Compiling hxcpp tool...");
   run("tools/hxcpp", 'haxe -m BuildTool -D HXCPP_STACK_TRACE -D HXCPP_STACK_LINE -D analyzer-optimise --cpp $_absOutDir --dce full');
   log("Initial setup complete.");
}

function compileHxcppTool(_absOutDir)
{
   if (isNonInteractive())
   {
      setup(_absOutDir);
   }
   else
   {
      log('This version of hxcpp (${ Sys.getCwd() }) has not yet been built for this platform');
      log("");
      log("Would you like to do this now [y/n]");

      switch Sys.getChar(true)
      {
         case 'y'.code, 'Y'.code:
            log("");
            setup(_absOutDir);

            return;
         case _:
            Sys.exit(-1);
      }
   }
}

function main()
{
   final absOutputDir = Path.join([ Sys.getCwd(), 'bin', Sys.systemName() ]);
   final absOutputExe = Path.join([ absOutputDir, if (Sys.systemName() == 'Windows') 'BuildTool.exe' else 'BuildTool' ]);

   if (!FileSystem.exists(absOutputExe))
   {
      compileHxcppTool(absOutputDir);
   }

   Sys.exit( Sys.command( absOutputExe, Sys.args() ) );
}