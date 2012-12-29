#!/usr/bin/env bash

prefix=`(cd \`dirname "${0}"\`; pwd)`

echo '<html>' > "$prefix/summary.html"
echo '<body>' >> "$prefix/summary.html"
echo '<table border="1">' >> "$prefix/summary.html"
echo '<tr>' >> "$prefix/summary.html"
echo '  <th rowspan="9">Configuration</th>' >> "$prefix/summary.html"
echo '  <th>Variant</th>' >> "$prefix/summary.html"
for variant in debug release profile; do
  echo "  <td colspan=\"256\">$variant</td>" >> "$prefix/summary.html"
done
echo '</tr>' >> "$prefix/summary.html"
echo '<tr>' >> "$prefix/summary.html"
echo '  <th>Link</th>' >> "$prefix/summary.html"
for i in `seq 1 3`; do
  for link in shared static; do
    echo "  <td colspan=\"128\">$link</td>" >> "$prefix/summary.html"
  done
done
echo '</tr>' >> "$prefix/summary.html"
echo '<tr>' >> "$prefix/summary.html"
echo '  <th>Threading</th>' >> "$prefix/summary.html"
for i in `seq 1 6`; do
  for threading in multi single; do
    echo "  <td colspan=\"64\">$threading</td>" >> "$prefix/summary.html"
  done
done
echo '</tr>' >> "$prefix/summary.html"
echo '<tr>' >> "$prefix/summary.html"
echo '  <th>Address Model</th>' >> "$prefix/summary.html"
for i in `seq 1 12`; do
  for address_model in 64 32; do
    echo "  <td colspan=\"32\">$address_model</td>" >> "$prefix/summary.html"
  done
done
echo '</tr>' >> "$prefix/summary.html"
echo '<tr>' >> "$prefix/summary.html"
echo '  <th>Instruction Set</th>' >> "$prefix/summary.html"
for i in `seq 1 24`; do
  for instruction_set in unspecified native; do
    echo "  <td colspan=\"16\">$instruction_set</td>" >> "$prefix/summary.html"
  done
done
echo '</tr>' >> "$prefix/summary.html"
echo '<tr>' >> "$prefix/summary.html"
echo '  <th>Language Standard</th>' >> "$prefix/summary.html"
for i in `seq 1 48`; do
  for std in c++03 c++11; do
    echo "  <td colspan=\"8\">$std</td>" >> "$prefix/summary.html"
  done
done
echo '</tr>' >> "$prefix/summary.html"
echo '<tr>' >> "$prefix/summary.html"
echo '  <th>Link-Time Optimization</th>' >> "$prefix/summary.html"
for i in `seq 1 96`; do
  for lto in off on; do
    echo "  <td colspan=\"4\">$lto</td>" >> "$prefix/summary.html"
  done
done
echo '</tr>' >> "$prefix/summary.html"
echo '<tr>' >> "$prefix/summary.html"
echo '  <th>Memory-Checking Instrumentation</th>' >> "$prefix/summary.html"
for i in `seq 1 192`; do
  for memory_checker in off on; do
    echo "  <td colspan=\"2\">$memory_checker</td>" >> "$prefix/summary.html"
  done
done
echo '</tr>' >> "$prefix/summary.html"
echo '<tr>' >> "$prefix/summary.html"
echo '  <th>libstdc++ Debug Mode</th>' >> "$prefix/summary.html"
for i in `seq 1 384`; do
  for libstdcxx_debug_mode in off on; do
    echo "  <td>$libstdcxx_debug_mode</td>" >> "$prefix/summary.html"
  done
done
echo '</tr>' >> "$prefix/summary.html"

for lib in binutils gmp mpfr mpc isl cloog ppl icu4c openmpi clang         \
           valgrind boost boost_accumulators boost_algorithm boost_any     \
           boost_array boost_asio boost_assign boost_atomic boost_bimap    \
           boost_bind boost_chrono boost_circular_buffer boost_config      \
           boost_container boost_context boost_conversion boost_coroutine  \
           boost_crc boost_date_time boost_exception boost_filesystem      \
           boost_flyweight boost_foreach boost_format boost_function       \
           boost_function_types boost_functional boost_fusion              \
           boost_geometry boost_gil boost_graph boost_graph_parallel       \
           boost_heap boost_icl boost_integer boost_interprocess           \
           boost_intrusive boost_iostreams boost_io boost_iterator         \
           boost_lambda boost_locale boost_local_function boost_lockfree   \
           boost_logic boost_math boost_move boost_mpi boost_mpl boost_msm \
           boost_multi_array boost_multi_index boost_multiprecision        \
           boost_optional boost_parameter boost_phoenix boost_polygon      \
           boost_pool boost_preprocessor boost_program_options             \
           boost_property_map boost_property_tree boost_proto              \
           boost_ptr_container boost_python boost_random boost_range       \
           boost_rational boost_ratio boost_regex boost_scope_exit         \
           boost_serialization boost_signals boost_signals2                \
           boost_smart_ptr boost_spirit boost_statechart boost_system      \
           boost_test boost_thread boost_timer boost_tokenizer boost_tr1   \
           boost_tuple boost_typeof boost_type_traits boost_units          \
           boost_unordered boost_utility boost_uuid boost_variant          \
           boost_xpressive; do
  echo '<tr>' >> "$prefix/summary.html"
  case $lib in
    'binutils') echo '  <th colspan="2">Binutils</th>' >> "$prefix/summary.html" ;;
    'gmp')      echo '  <th colspan="2">GMP</th>' >> "$prefix/summary.html" ;;
    'mpfr')     echo '  <th colspan="2">MPFR</th>' >> "$prefix/summary.html" ;;
    'mpc')      echo '  <th colspan="2">MPC</th>' >> "$prefix/summary.html" ;;
    'isl')      echo '  <th colspan="2">ISL</th>' >> "$prefix/summary.html" ;;
    'cloog')    echo '  <th colspan="2">CLooG</th>' >> "$prefix/summary.html" ;;
    'ppl')      echo '  <th colspan="2">PPL</th>' >> "$prefix/summary.html" ;;
    'icu4c')    echo '  <th colspan="2">ICU4C</th>' >> "$prefix/summary.html" ;;
    'openmpi')  echo '  <th colspan="2">Open MPI</th>' >> "$prefix/summary.html" ;;
    'clang')    echo '  <th colspan="2">LLVM / clang</th>' >> "$prefix/summary.html" ;;
    'valgrind') echo '  <th colspan="2">Valgrind</th>' >> "$prefix/summary.html" ;;
    'boost')    echo '  <th colspan="2">Boost (build & install)</th>' >> "$prefix/summary.html" ;;
    'boost_accumulators')    echo '  <th colspan="2">Boost.Accumulators</th>' >> "$prefix/summary.html" ;;
    'boost_algorithm')       echo '  <th colspan="2">Boost.Algorithm</th>' >> "$prefix/summary.html" ;;
    'boost_any')             echo '  <th colspan="2">Boost.Any</th>' >> "$prefix/summary.html" ;;
    'boost_array')           echo '  <th colspan="2">Boost.Array</th>' >> "$prefix/summary.html" ;;
    'boost_asio')            echo '  <th colspan="2">Boost.Asio</th>' >> "$prefix/summary.html" ;;
    'boost_assign')          echo '  <th colspan="2">Boost.Assign</th>' >> "$prefix/summary.html" ;;
    'boost_atomic')          echo '  <th colspan="2">Boost.Atomic</th>' >> "$prefix/summary.html" ;;
    'boost_bimap')           echo '  <th colspan="2">Boost.Bimap</th>' >> "$prefix/summary.html" ;;
    'boost_bind')            echo '  <th colspan="2">Boost.Bind</th>' >> "$prefix/summary.html" ;;
    'boost_chrono')          echo '  <th colspan="2">Boost.Chrono</th>' >> "$prefix/summary.html" ;;
    'boost_circular_buffer') echo '  <th colspan="2">Boost.CircularBuffer</th>' >> "$prefix/summary.html" ;;
    'boost_config')          echo '  <th colspan="2">Boost.Config</th>' >> "$prefix/summary.html" ;;
    'boost_container')       echo '  <th colspan="2">Boost.Container</th>' >> "$prefix/summary.html" ;;
    'boost_context')         echo '  <th colspan="2">Boost.Context</th>' >> "$prefix/summary.html" ;;
    'boost_conversion')      echo '  <th colspan="2">Boost.Conversion</th>' >> "$prefix/summary.html" ;;
    'boost_coroutine')       echo '  <th colspan="2">Boost.Coroutine</th>' >> "$prefix/summary.html" ;;
    'boost_crc')             echo '  <th colspan="2">Boost.CRC</th>' >> "$prefix/summary.html" ;;
    'boost_date_time')       echo '  <th colspan="2">Boost.Date_Time</th>' >> "$prefix/summary.html" ;;
    'boost_exception')       echo '  <th colspan="2">Boost.Exception</th>' >> "$prefix/summary.html" ;;
    'boost_filesystem')      echo '  <th colspan="2">Boost.Filesystem</th>' >> "$prefix/summary.html" ;;
    'boost_flyweight')       echo '  <th colspan="2">Boost.Flyweight</th>' >> "$prefix/summary.html" ;;
    'boost_foreach')         echo '  <th colspan="2">Boost.Foreach</th>' >> "$prefix/summary.html" ;;
    'boost_format')          echo '  <th colspan="2">Boost.Format</th>' >> "$prefix/summary.html" ;;
    'boost_function')        echo '  <th colspan="2">Boost.Function</th>' >> "$prefix/summary.html" ;;
    'boost_function_types')  echo '  <th colspan="2">Boost.FunctionTypes</th>' >> "$prefix/summary.html" ;;
    'boost_functional')      echo '  <th colspan="2">Boost.Functional</th>' >> "$prefix/summary.html" ;;
    'boost_fusion')          echo '  <th colspan="2">Boost.Fusion</th>' >> "$prefix/summary.html" ;;
    'boost_geometry')        echo '  <th colspan="2">Boost.Geometry</th>' >> "$prefix/summary.html" ;;
    'boost_gil')             echo '  <th colspan="2">Boost.GIL</th>' >> "$prefix/summary.html" ;;
    'boost_graph')           echo '  <th colspan="2">Boost.Graph</th>' >> "$prefix/summary.html" ;;
    'boost_graph_parallel')  echo '  <th colspan="2">Boost.GraphParallel</th>' >> "$prefix/summary.html" ;;
    'boost_heap')            echo '  <th colspan="2">Boost.Heap</th>' >> "$prefix/summary.html" ;;
    'boost_icl')             echo '  <th colspan="2">Boost.Icl</th>' >> "$prefix/summary.html" ;;
    'boost_integer')         echo '  <th colspan="2">Boost.Integer</th>' >> "$prefix/summary.html" ;;
    'boost_interprocess')    echo '  <th colspan="2">Boost.Interprocess</th>' >> "$prefix/summary.html" ;;
    'boost_intrusive')       echo '  <th colspan="2">Boost.Intrusive</th>' >> "$prefix/summary.html" ;;
    'boost_iostreams')       echo '  <th colspan="2">Boost.Iostreams</th>' >> "$prefix/summary.html" ;;
    'boost_io')              echo '  <th colspan="2">Boost.Io</th>' >> "$prefix/summary.html" ;;
    'boost_iterator')        echo '  <th colspan="2">Boost.Iterator</th>' >> "$prefix/summary.html" ;;
    'boost_lambda')          echo '  <th colspan="2">Boost.Lambda</th>' >> "$prefix/summary.html" ;;
    'boost_local_function')  echo '  <th colspan="2">Boost.LocalFunction</th>' >> "$prefix/summary.html" ;;
    'boost_locale')          echo '  <th colspan="2">Boost.Locale</th>' >> "$prefix/summary.html" ;;
    'boost_lockfree')        echo '  <th colspan="2">Boost.Lockfree</th>' >> "$prefix/summary.html" ;;
    'boost_logic')           echo '  <th colspan="2">Boost.Logic</th>' >> "$prefix/summary.html" ;;
    'boost_math')            echo '  <th colspan="2">Boost.Math</th>' >> "$prefix/summary.html" ;;
    'boost_move')            echo '  <th colspan="2">Boost.Move</th>' >> "$prefix/summary.html" ;;
    'boost_mpi')             echo '  <th colspan="2">Boost.MPI</th>' >> "$prefix/summary.html" ;;
    'boost_mpl')             echo '  <th colspan="2">Boost.MPL</th>' >> "$prefix/summary.html" ;;
    'boost_msm')             echo '  <th colspan="2">Boost.MSM</th>' >> "$prefix/summary.html" ;;
    'boost_multi_array')     echo '  <th colspan="2">Boost.MultiArray</th>' >> "$prefix/summary.html" ;;
    'boost_multi_index')     echo '  <th colspan="2">Boost.MultiIndex</th>' >> "$prefix/summary.html" ;;
    'boost_multiprecision')  echo '  <th colspan="2">Boost.Multiprecision</th>' >> "$prefix/summary.html" ;;
    'boost_optional')        echo '  <th colspan="2">Boost.Optional</th>' >> "$prefix/summary.html" ;;
    'boost_parameter')       echo '  <th colspan="2">Boost.Parameter</th>' >> "$prefix/summary.html" ;;
    'boost_phoenix')         echo '  <th colspan="2">Boost.Phoenix</th>' >> "$prefix/summary.html" ;;
    'boost_ptr_container')   echo '  <th colspan="2">Boost.PointerContainer</th>' >> "$prefix/summary.html" ;;
    'boost_polygon')         echo '  <th colspan="2">Boost.Polygon</th>' >> "$prefix/summary.html" ;;
    'boost_pool')            echo '  <th colspan="2">Boost.Pool</th>' >> "$prefix/summary.html" ;;
    'boost_preprocessor')    echo '  <th colspan="2">Boost.Preprocessor</th>' >> "$prefix/summary.html" ;;
    'boost_program_options') echo '  <th colspan="2">Boost.Program_options</th>' >> "$prefix/summary.html" ;;
    'boost_property_map')    echo '  <th colspan="2">Boost.PropertyMap</th>' >> "$prefix/summary.html" ;;
    'boost_property_tree')   echo '  <th colspan="2">Boost.PropertyTree</th>' >> "$prefix/summary.html" ;;
    'boost_proto')           echo '  <th colspan="2">Boost.Proto</th>' >> "$prefix/summary.html" ;;
    'boost_python')          echo '  <th colspan="2">Boost.Python</th>' >> "$prefix/summary.html" ;;
    'boost_random')          echo '  <th colspan="2">Boost.Random</th>' >> "$prefix/summary.html" ;;
    'boost_range')           echo '  <th colspan="2">Boost.Range</th>' >> "$prefix/summary.html" ;;
    'boost_ratio')           echo '  <th colspan="2">Boost.Ratio</th>' >> "$prefix/summary.html" ;;
    'boost_rational')        echo '  <th colspan="2">Boost.Rational</th>' >> "$prefix/summary.html" ;;
    'boost_regex')           echo '  <th colspan="2">Boost.Regex</th>' >> "$prefix/summary.html" ;;
    'boost_scope_exit')      echo '  <th colspan="2">Boost.ScopeExit</th>' >> "$prefix/summary.html" ;;
    'boost_serialization')   echo '  <th colspan="2">Boost.Serialization</th>' >> "$prefix/summary.html" ;;
    'boost_signals')         echo '  <th colspan="2">Boost.Signals</th>' >> "$prefix/summary.html" ;;
    'boost_signals2')        echo '  <th colspan="2">Boost.Signals2</th>' >> "$prefix/summary.html" ;;
    'boost_smart_ptr')       echo '  <th colspan="2">Boost.SmartPointers</th>' >> "$prefix/summary.html" ;;
    'boost_spirit')          echo '  <th colspan="2">Boost.Spirit</th>' >> "$prefix/summary.html" ;;
    'boost_statechart')      echo '  <th colspan="2">Boost.Statechart</th>' >> "$prefix/summary.html" ;;
    'boost_system')          echo '  <th colspan="2">Boost.System</th>' >> "$prefix/summary.html" ;;
    'boost_test')            echo '  <th colspan="2">Boost.Test</th>' >> "$prefix/summary.html" ;;
    'boost_thread')          echo '  <th colspan="2">Boost.Thread</th>' >> "$prefix/summary.html" ;;
    'boost_timer')           echo '  <th colspan="2">Boost.Timer</th>' >> "$prefix/summary.html" ;;
    'boost_tokenizer')       echo '  <th colspan="2">Boost.Tokenizer</th>' >> "$prefix/summary.html" ;;
    'boost_tr1')             echo '  <th colspan="2">Boost.TR1</th>' >> "$prefix/summary.html" ;;
    'boost_tuple')           echo '  <th colspan="2">Boost.Tuple</th>' >> "$prefix/summary.html" ;;
    'boost_type_traits')     echo '  <th colspan="2">Boost.TypeTraits</th>' >> "$prefix/summary.html" ;;
    'boost_typeof')          echo '  <th colspan="2">Boost.Typeof</th>' >> "$prefix/summary.html" ;;
    'boost_units')           echo '  <th colspan="2">Boost.Units</th>' >> "$prefix/summary.html" ;;
    'boost_unordered')       echo '  <th colspan="2">Boost.Unordered</th>' >> "$prefix/summary.html" ;;
    'boost_utility')         echo '  <th colspan="2">Boost.Utility</th>' >> "$prefix/summary.html" ;;
    'boost_uuid')            echo '  <th colspan="2">Boost.UUID</th>' >> "$prefix/summary.html" ;;
    'boost_variant')         echo '  <th colspan="2">Boost.Variant</th>' >> "$prefix/summary.html" ;;
    'boost_xpressive')       echo '  <th colspan="2">Boost.Xpressive</th>' >> "$prefix/summary.html" ;;
    *)          echo "  <th colspan=\"2\">$lib</th>" >> "$prefix/summary.html" ;;
  esac
  for variant in debug release profile; do
    for link in shared static; do
      for threading in multi single; do
        for address_model in 64 32; do
	  for instruction_set in unspecified native; do
	    for std in c++03 c++11; do
	      for lto in off on; do
	        for memory_checker in off on; do
		  for libstdcxx_debug_mode in off on; do
		    logfile="$variant/link-$link/threading-$threading/address-model-$address_model/instruction-set-$instruction_set/$std/lto-$lto/memory-checker-$memory_checker/libstdc++-debug-mode-$libstdcxx_debug_mode/$lib.txt"
		    if [ -f "$prefix/$logfile" ]; then
                      if grep -Fq 'successful completion' "$prefix/$logfile"; then
                        echo "  <td bgcolor=\"lime\"><a href=\"$logfile\">PASS</a></td>" >> "$prefix/summary.html"
                      else
                        echo "  <td bgcolor=\"red\"><a href=\"$logfile\">FAIL</a></td>" >> "$prefix/summary.html"
                      fi
		    else
		      echo "  <td bgcolor=\"gray\">N/A</td>" >> "$prefix/summary.html"
		    fi
		  done
		done
	      done
	    done
	  done
	done
      done
    done
  done
  echo '</tr>' >> "$prefix/summary.html"
done

echo '</table>' >> "$prefix/summary.html"
echo '</body>' >> "$prefix/summary.html"
echo '</html>' >> "$prefix/summary.html"
